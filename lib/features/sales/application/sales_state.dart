import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_paint_store_app/data/mock_data.dart';
import 'package:flutter_paint_store_app/features/color_palette/application/color_palette_state.dart';
import 'package:flutter_paint_store_app/models/cost_item.dart';
import 'package:flutter_paint_store_app/models/customer.dart';
import 'package:collection/collection.dart';
import 'package:flutter_paint_store_app/models/paint_color.dart';
import 'package:flutter_paint_store_app/models/product.dart';
import 'package:flutter_paint_store_app/models/quote.dart';
import 'package:flutter_paint_store_app/features/sales/application/price_service.dart';

// --- Các provider cho trạng thái UI ---

// Provider để lưu trữ chuỗi tìm kiếm trên màn hình bán hàng
final salesSearchQueryProvider = StateProvider<String>((ref) => '', name: 'salesSearchQueryProvider');
// Provider để kiểm tra xem giỏ hàng có đang được hiển thị trên mobile không
final isShowingCartMobileProvider = StateProvider<bool>((ref) => false, name: 'isShowingCartMobileProvider');
// Provider để kiểm tra xem có đang in báo giá không
final isPrintingProvider = StateProvider<bool>((ref) => false, name: 'isPrintingProvider');

// --- Các provider cho dữ liệu ---

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

// Notifier để quản lý trạng thái của báo giá hiện tại
class QuoteNotifier extends StateNotifier<Quote> {
  QuoteNotifier(this.ref)
      : super(
          Quote(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            items: [],
            createdAt: DateTime.now(),
          ),
        );

  final Ref ref;

  // Thêm một sản phẩm vào báo giá
  void addItem({
    required Product product,
    PaintColor? color,
    int quantity = 1,
  }) {
    final existingItem = state.items.firstWhereOrNull(
      (item) => item.product.id == product.id && item.color?.id == color?.id,
    );

    if (existingItem != null) {
      updateQuantity(existingItem.id, existingItem.quantity + quantity);
    } else {
      final unitPrice = _calculateUnitPrice(product: product);
      final tintingCost = color != null ? _calculateTintingCost(product, color) : 0.0;

      if (unitPrice == null || tintingCost == null) return;

      final newItem = QuoteItem(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        product: product,
        color: color,
        quantity: quantity,
        unitPrice: unitPrice,
        tintingCost: tintingCost,
        note: color != null ? '${color.code} ${color.name}' : null,
      );
      state = state.copyWith(items: [...state.items, newItem]);
    }
  }

  // Thêm một danh sách các mục chi phí (từ dialog chi tiết giá) vào báo giá
  void addCostItems(List<CostItem> costItems, PaintColor color) {
    final newQuoteItems = costItems.map((costItem) {
      // Tính toán đơn giá cuối cùng theo yêu cầu
      final finalUnitPrice = costItem.unitPrice + costItem.tintCost - costItem.discount;

      return QuoteItem(
        id: DateTime.now().millisecondsSinceEpoch.toString() + costItem.product.id,
        product: costItem.product,
        color: color,
        quantity: costItem.quantity,
        // Đưa đơn giá cuối cùng vào trường unitPrice
        unitPrice: finalUnitPrice,
        // Đặt tintingCost và discountValue thành 0 để tránh tính trùng lặp
        tintingCost: 0,
        discountValue: 0,
        isDiscountPercentage: false,
        note: '${color.code} ${color.name}',
      );
    }).toList();

    state = state.copyWith(items: [...state.items, ...newQuoteItems]);
  }

  // Thêm một bản sao của một mục trong báo giá
  void addDuplicateItem(QuoteItem item) {
    final newItem = item.copyWith(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
    );
    state = state.copyWith(items: [...state.items, newItem]);
  }

  // Cập nhật số lượng của một mục trong báo giá
  void updateQuantity(String quoteItemId, int newQuantity) {
    final items = List<QuoteItem>.from(state.items);
    final itemIndex = items.indexWhere((item) => item.id == quoteItemId);

    if (itemIndex != -1) {
      if (newQuantity > 0) {
        items[itemIndex] = items[itemIndex].copyWith(quantity: newQuantity);
        state = state.copyWith(items: items);
      } else {
        removeItem(quoteItemId);
      }
    }
  }

  // Xóa một mục khỏi báo giá
  void removeItem(String quoteItemId) {
    state = state.copyWith(
      items: state.items.where((item) => item.id != quoteItemId).toList(),
    );
  }

  // Cập nhật đơn giá của một mục trong báo giá
  void updateUnitPrice(String quoteItemId, double newUnitPrice) {
    final items = List<QuoteItem>.from(state.items);
    final itemIndex = items.indexWhere((item) => item.id == quoteItemId);

    if (itemIndex != -1) {
      items[itemIndex] = items[itemIndex].copyWith(unitPrice: newUnitPrice);
      state = state.copyWith(items: items);
    }
  }

  // Áp dụng giảm giá cho một mục trong báo giá
  void applyDiscount(String quoteItemId, double value, bool isPercentage) {
    final items = List<QuoteItem>.from(state.items);
    final itemIndex = items.indexWhere((item) => item.id == quoteItemId);

    if (itemIndex != -1) {
      items[itemIndex] = items[itemIndex].copyWith(
        discountValue: value,
        isDiscountPercentage: isPercentage,
      );
      state = state.copyWith(items: items);
    }
  }

  // Cập nhật ghi chú cho một mục trong báo giá
  void updateNote(String quoteItemId, String note) {
    final items = List<QuoteItem>.from(state.items);
    final itemIndex = items.indexWhere((item) => item.id == quoteItemId);

    if (itemIndex != -1) {
      items[itemIndex] = items[itemIndex].copyWith(note: note);
      state = state.copyWith(items: items);
    }
  }

  // Cập nhật tất cả giá trong báo giá dựa trên bảng giá đã chọn
  void updateAllPrices() {
    final newPriceList = ref.read(selectedPriceListProvider);
    final updatedItems = state.items.map((item) {
      final newPrice = _calculateUnitPrice(product: item.product, priceList: newPriceList);
      final newTintingCost = item.color != null ? _calculateTintingCost(item.product, item.color!) : 0.0;
      return item.copyWith(unitPrice: newPrice ?? item.unitPrice, tintingCost: newTintingCost ?? item.tintingCost);
    }).toList();
    state = state.copyWith(items: updatedItems);
  }

  // Tính toán đơn giá dựa trên bảng giá
  double? _calculateUnitPrice({required Product product, String? priceList}) {
    final selectedPriceList = priceList ?? ref.read(selectedPriceListProvider);
    return product.prices[selectedPriceList] ?? product.basePrice;
  }

  // Tính toán chi phí pha màu
  double? _calculateTintingCost(Product product, PaintColor color) {
    final priceService = ref.read(priceServiceProvider);
    final finalPrice = priceService.getFinalPrice(color, product);
    if (finalPrice == null) {
      return null;
    }
    return finalPrice - product.basePrice;
  }

  // Xóa tất cả các mục trong báo giá
  void clear() {
    state = state.copyWith(items: [], customer: null);
  }

  // Sắp xếp lại thứ tự các mục trong báo giá
  void reorderItem(int oldIndex, int newIndex) {
    final items = List<QuoteItem>.from(state.items);
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final item = items.removeAt(oldIndex);
    items.insert(newIndex, item);
    state = state.copyWith(items: items);
  }
}

// Provider chính cho báo giá
final quoteProvider = StateNotifierProvider<QuoteNotifier, Quote>((ref) {
  final notifier = QuoteNotifier(ref);

  // Lắng nghe sự thay đổi của bảng giá và cập nhật lại tất cả giá
  ref.listen<String?>(selectedPriceListProvider, (previous, next) {
    if (previous != next) {
      notifier.updateAllPrices();
    }
  });

  return notifier;
}, name: 'quoteProvider');

// Provider để tính tổng tiền của báo giá
final quoteTotalProvider = Provider<double>((ref) {
  final quoteItems = ref.watch(quoteProvider).items;
  if (quoteItems.isEmpty) return 0.0;
  return quoteItems.fold(0.0, (sum, item) => sum + item.totalPrice);
}, name: 'quoteTotalProvider');

// Provider cho danh sách khách hàng (dữ liệu giả)
final customersProvider = Provider<List<Customer>>((ref) {
  return [
    Customer(id: '1', name: 'Khách lẻ', phone: '', address: ''),
    Customer(id: '2', name: 'Anh Sơn - Cầu Giấy', phone: '', address: ''),
    Customer(id: '3', name: 'Công ty Xây dựng ABC', phone: '', address: ''),
  ];
}, name: 'customersProvider');

// Provider cho khách hàng đã chọn
final selectedCustomerProvider = StateProvider<Customer?>((ref) {
  return ref.watch(customersProvider).first;
}, name: 'selectedCustomerProvider');

// Provider cho danh sách các bảng giá
final priceListsProvider = Provider<List<String>>((ref) {
  return ['Giá bán lẻ', 'Giá đại lý cấp 1', 'Giá dự án'];
}, name: 'priceListsProvider');

// Provider cho bảng giá đã chọn
final selectedPriceListProvider = StateProvider<String?>((ref) {
  return ref.watch(priceListsProvider).first;
}, name: 'selectedPriceListProvider');
