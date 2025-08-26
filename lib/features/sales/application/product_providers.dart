import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_paint_store_app/data/mock_data.dart';
import 'package:flutter_paint_store_app/models/product.dart';
import 'package:flutter_paint_store_app/features/sales/application/ui_state_providers.dart';

// Provider để lấy danh sách sản phẩm bán hàng (dữ liệu giả)
final salesProductsProvider = FutureProvider<List<Product>>((ref) async {
  await Future.delayed(const Duration(milliseconds: 300));
  return mockSalesProducts;
}, name: 'salesProductsProvider');

// Provider để lọc danh sách sản phẩm bán hàng dựa trên chuỗi tìm kiếm
final filteredSalesProductsProvider = Provider<List<Product>>((ref) {
  final query = ref.watch(salesSearchQueryProvider);
  final productsAsyncValue = ref.watch(salesProductsProvider);

  return productsAsyncValue.when(
    data: (products) {
      if (query.isEmpty) {
        return products;
      }
      final lowerCaseQuery = query.toLowerCase();
      return products
          .where(
            (product) =>
                product.name.toLowerCase().contains(lowerCaseQuery) ||
                product.code.toLowerCase().contains(lowerCaseQuery),
          )
          .toList();
    },
    loading: () => [],
    error: (err, stack) => [],
  );
}, name: 'filteredSalesProductsProvider');
