import 'package:flutter_riverpod/flutter_riverpod.dart';

// Provider để lưu trữ chuỗi tìm kiếm trên màn hình bán hàng
final salesSearchQueryProvider = StateProvider<String>(
  (ref) => '',
  name: 'salesSearchQueryProvider',
);
// Provider để kiểm tra xem giỏ hàng có đang được hiển thị trên mobile không
final isShowingCartMobileProvider = StateProvider<bool>(
  (ref) => false,
  name: 'isShowingCartMobileProvider',
);
// Provider để kiểm tra xem có đang in báo giá không
final isPrintingProvider = StateProvider<bool>(
  (ref) => false,
  name: 'isPrintingProvider',
);

// Provider cho danh sách các bảng giá
final priceListsProvider = Provider<List<String>>((ref) {
  return ['Giá bán lẻ', 'Giá đại lý cấp 1', 'Giá dự án'];
}, name: 'priceListsProvider');
