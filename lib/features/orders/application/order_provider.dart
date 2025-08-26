import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/order.dart';
import '../data/mock_order_repository.dart';
import '../domain/order_repository.dart';

// 1. Repository Provider
// Cung cấp một thể hiện của OrderRepository.
// Trong ứng dụng thực tế, bạn có thể thay thế MockOrderRepository() bằng
// một lớp khác (ví dụ: ApiOrderRepository()) mà không cần thay đổi UI.
final orderRepositoryProvider = Provider<OrderRepository>((ref) {
  return MockOrderRepository();
});

// 2. Data Provider
// Provider này sử dụng repository để lấy danh sách đơn hàng.
// UI sẽ "watch" provider này để tự động cập nhật.
final ordersProvider = FutureProvider<List<Order>>((ref) {
  final orderRepository = ref.watch(orderRepositoryProvider);
  return orderRepository.getOrders();
});

