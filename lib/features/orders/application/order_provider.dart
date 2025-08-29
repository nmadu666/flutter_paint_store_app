import 'package:cloud_firestore/cloud_firestore.dart' hide Order;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_paint_store_app/features/kiot_viet/application/kiot_viet_service.dart';

import '../../../models/customer.dart';
import '../../../models/order.dart';
import '../data/kiot_viet_order_repository.dart';
import '../domain/order_repository.dart';

// Helper class to hold combined Order and Customer data
class OrderWithCustomer {
  final Order order;
  final Customer? customer; // Customer can be null if not found

  OrderWithCustomer({required this.order, this.customer});
}

// 1. Repository Provider
final orderRepositoryProvider = Provider<OrderRepository>((ref) {
  final kiotVietService = ref.watch(kiotVietServiceProvider);
  final firestore = FirebaseFirestore.instance;
  return KiotVietOrderRepository(kiotVietService, firestore);
});

// 2. KiotViet Orders Provider
// Fetches the raw list of orders from the repository.
final kiotVietOrdersProvider = FutureProvider<List<Order>>((ref) {
  final orderRepository = ref.watch(orderRepositoryProvider);
  return orderRepository.getOrders();
});

// 3. Firebase Customers Provider
// Provides a stream of customers from Firestore.
final firebaseCustomersProvider = StreamProvider<List<Customer>>((ref) {
  final firestore = FirebaseFirestore.instance;
  return firestore
      .collection('customers')
      .snapshots()
      .map((snapshot) => snapshot.docs.map((doc) => Customer.fromJson(doc.data())).toList());
});

// 4. Combined Data Provider
// This is the main provider the UI will watch. It combines orders with customer data.
final ordersProvider = FutureProvider<List<OrderWithCustomer>>((ref) async {
  // 1. Await the result of the orders future.
  // The FutureProvider will automatically handle loading/error states.
  final orders = await ref.watch(kiotVietOrdersProvider.future);

  // 2. Get the latest customer data from the stream.
  // This will also make the provider re-run whenever customer data changes.
  final customers = ref.watch(firebaseCustomersProvider).value ?? [];

  // 3. If there are no customers yet, we can return early or proceed with null customers.
  // Here, we proceed, allowing for orders with no matching customer.
  final customerMap = {for (var c in customers) c.id: c};

  // 4. Combine the data.
  final combinedList = orders.map((order) {
    return OrderWithCustomer(
      order: order,
      customer: customerMap[order.customerId],
    );
  }).toList();

  return combinedList;
});

// 5. Provider to fetch a single, detailed order by its ID.
// The UI (e.g., a detail dialog) can use this provider.
final orderByIdProvider = FutureProvider.family<Order, int>((ref, orderId) {
  final orderRepository = ref.watch(orderRepositoryProvider);
  return orderRepository.getOrderById(orderId);
});
