import 'package:cloud_firestore/cloud_firestore.dart' hide Order;
import 'package:flutter/foundation.dart';
import 'package:flutter_paint_store_app/features/kiot_viet/application/kiot_viet_service.dart'
    show KiotVietService;
import 'package:flutter_paint_store_app/models/order.dart';

import '../domain/order_repository.dart';

class KiotVietOrderRepository implements OrderRepository {
  final KiotVietService _kiotVietService;
  final FirebaseFirestore _firestore;

  KiotVietOrderRepository(this._kiotVietService, this._firestore);

  @override
  Future<List<Order>> getOrders() async {
    // 1. Fetch all orders from KiotViet API with specific parameters
    final params = {
      // The service's getAll method already uses pageSize=100
      'status':
          '1,2,5', // Filter by status (1: Hoàn thành, 2: Đang xử lý, 5: Đã đối soát)
      'orderBy': 'createdDate',
      'orderDirection':
          'Desc', // Corrected from 'Desk' to 'Desc' for descending
    };
    final rawOrders = await _kiotVietService.getAll('orders', params: params);

    if (rawOrders.isEmpty) {
      return [];
    }

    final allOrders = rawOrders.map((json) => Order.fromJson(json)).toList();

    // 2. Collect unique IDs from all orders to check for existence in Firebase
    final customerIds = <String>{};
    final branchIds = <String>{};
    final productIds = <String>{};

    for (final order in allOrders) {
      if (order.customerId != null) {
        customerIds.add(order.customerId.toString());
      }
      if (order.branchId != null) branchIds.add(order.branchId.toString());
      for (final detail in order.orderDetails) {
        productIds.add(detail.productId.toString());
      }
    }

    // 3. Check which IDs actually exist in Firebase
    final existingCustomerIds = await _checkIdsExist('customers', customerIds);
    final existingBranchIds = await _checkIdsExist('branches', branchIds);
    final existingProductIds = await _checkIdsExist('products', productIds);

    // 4. (Optional but recommended) Log missing IDs for debugging
    _logMissingIds('customer', customerIds, existingCustomerIds);
    _logMissingIds('branch', branchIds, existingBranchIds);
    _logMissingIds('product', productIds, existingProductIds);

    // 5. Filter out orders that have references to non-synced data
    final validOrders = allOrders.where((order) {
      final isCustomerValid =
          order.customerId == null ||
          existingCustomerIds.contains(order.customerId.toString());
      final isBranchValid =
          order.branchId == null ||
          existingBranchIds.contains(order.branchId.toString());

      final areDetailsValid = order.orderDetails.every((detail) {
        final isProductValid = existingProductIds.contains(
          detail.productId.toString(),
        );
        // Add checks for other IDs like priceBookId if needed
        return isProductValid;
      });

      if (!isCustomerValid) {
        debugPrint(
          'Order ${order.code} skipped: Missing customer ${order.customerId}',
        );
      }
      if (!isBranchValid) {
        debugPrint(
          'Order ${order.code} skipped: Missing branch ${order.branchId}',
        );
      }
      if (!areDetailsValid) {
        debugPrint('Order ${order.code} skipped: Contains missing products');
      }

      return isCustomerValid && isBranchValid && areDetailsValid;
    }).toList();

    debugPrint(
      'Fetched ${allOrders.length} orders from KiotViet, returning ${validOrders.length} valid orders after Firebase sync check.',
    );

    return validOrders;
  }

  /// Checks a set of document IDs against a Firestore collection.
  /// Handles Firestore's 'whereIn' query limit of 30 items per query.
  Future<Set<String>> _checkIdsExist(
    String collectionPath,
    Set<String> ids,
  ) async {
    if (ids.isEmpty) {
      return <String>{};
    }

    final existingIds = <String>{};
    final idList = ids.toList();

    // Firestore 'whereIn' supports up to 30 elements per query.
    // We need to chunk the IDs into batches of 30.
    for (var i = 0; i < idList.length; i += 30) {
      final chunk = idList.sublist(
        i,
        i + 30 > idList.length ? idList.length : i + 30,
      );
      if (chunk.isEmpty) continue;

      try {
        final querySnapshot = await _firestore
            .collection(collectionPath)
            .where(FieldPath.documentId, whereIn: chunk)
            .get();

        for (final doc in querySnapshot.docs) {
          existingIds.add(doc.id);
        }
      } catch (e) {
        debugPrint("Error checking IDs in '$collectionPath': $e");
      }
    }
    return existingIds;
  }

  void _logMissingIds(
    String type,
    Set<String> allIds,
    Set<String> existingIds,
  ) {
    final missingIds = allIds.difference(existingIds);
    if (missingIds.isNotEmpty) {
      debugPrint(
        'WARNING: The following $type IDs from KiotViet orders are NOT found in Firebase: $missingIds. Please run data sync.',
      );
    }
  }

  @override
  Future<Order> getOrderById(int id) async {
    // Call the KiotViet service to get a single order by its ID.
    final rawOrder = await _kiotVietService.get('orders/$id');
    // Parse the JSON response into our detailed Order model.
    return Order.fromJson(rawOrder);
  }
}
