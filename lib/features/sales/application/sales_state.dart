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

// --- Notifier để quản lý danh sách khách hàng ---
class CustomersNotifier extends StateNotifier<List<Customer>> {
  CustomersNotifier() : super(mockCustomers);

  // Thêm một khách hàng mới vào danh sách
  void addCustomer(Customer customer) {
    state = [...state, customer];
  }

  // Cập nhật một khách hàng đã có
  void updateCustomer(Customer updatedCustomer) {
    state = [
      for (final customer in state)
        if (customer.id == updatedCustomer.id) updatedCustomer else customer,
    ];
  }
}

// Provider cho CustomersNotifier
final customersProvider =
    StateNotifierProvider<CustomersNotifier, List<Customer>>((ref) {
      return CustomersNotifier();
    });

// Notifier để quản lý trạng thái của báo giá hiện tại
class QuoteNotifier extends StateNotifier<Quote> {
  QuoteNotifier(this.ref) : super(Quote.initial()) {
    // Khởi tạo báo giá với khách hàng và bảng giá mặc định (ID 1 là "Khách lẻ")
    final initialCustomer = ref.read(customersProvider).first;
    final initialPriceList = ref.read(priceListsProvider).first;
    state = state.copyWith(
      customer: initialCustomer,
      priceList: initialPriceList,
    );
  }

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
      final unitPrice = _calculateUnitPrice(
        product: product,
        priceList: state.priceList,
      );
      final tintingCost = color != null
          ? _calculateTintingCost(product, color)
          : 0.0;

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
      final finalUnitPrice =
          costItem.unitPrice + costItem.tintCost - costItem.discount;

      return QuoteItem(
        id:
            DateTime.now().millisecondsSinceEpoch.toString() +
            costItem.product.id,
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

  // Phương thức private helper để cập nhật một mục trong danh sách
  void _updateItem(String quoteItemId, QuoteItem Function(QuoteItem) updater) {
    state = state.copyWith(
      items: state.items.map((item) {
        if (item.id == quoteItemId) {
          return updater(item);
        }
        return item;
      }).toList(),
    );
  }

  // Cập nhật số lượng của một mục trong báo giá
  void updateQuantity(String quoteItemId, int newQuantity) {
    if (newQuantity > 0) {
      _updateItem(quoteItemId, (item) => item.copyWith(quantity: newQuantity));
    } else {
      removeItem(quoteItemId);
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
    _updateItem(quoteItemId, (item) => item.copyWith(unitPrice: newUnitPrice));
  }

  // Áp dụng giảm giá cho một mục trong báo giá
  void applyDiscount(String quoteItemId, double value, bool isPercentage) {
    _updateItem(
      quoteItemId,
      (item) => item.copyWith(
        discountValue: value,
        isDiscountPercentage: isPercentage,
      ),
    );
  }

  // Cập nhật ghi chú cho một mục trong báo giá
  void updateNote(String quoteItemId, String note) {
    _updateItem(quoteItemId, (item) => item.copyWith(note: note));
  }

  // Cập nhật khách hàng cho báo giá
  void selectCustomer(Customer customer) {
    state = state.copyWith(customer: customer);
  }

  // Thêm khách hàng mới và chọn khách hàng đó cho báo giá
  void addCustomerAndSelect(Customer newCustomer) {
    ref.read(customersProvider.notifier).addCustomer(newCustomer);
    // Tự động chọn khách hàng vừa tạo
    state = state.copyWith(customer: newCustomer);
  }

  // Cập nhật thông tin khách hàng
  void updateCustomer(Customer updatedCustomer) {
    ref.read(customersProvider.notifier).updateCustomer(updatedCustomer);
    // Nếu khách hàng được cập nhật là khách hàng đang được chọn, hãy làm mới state
    if (state.customer?.id == updatedCustomer.id) {
      state = state.copyWith(customer: updatedCustomer);
    }
  }

  // Cập nhật bảng giá và tính toán lại tất cả giá trong báo giá
  void selectPriceList(String newPriceList) {
    // Cập nhật bảng giá trong state
    state = state.copyWith(priceList: newPriceList);
    // Cập nhật lại giá của tất cả các mục
    _updateAllPrices();
  }

  // Cập nhật tất cả giá trong báo giá dựa trên bảng giá đã chọn
  void _updateAllPrices() {
    final newPriceList = state.priceList;
    final updatedItems = state.items.map((item) {
      final newPrice = _calculateUnitPrice(
        product: item.product,
        priceList: newPriceList,
      );
      final newTintingCost = item.color != null
          ? _calculateTintingCost(item.product, item.color!)
          : 0.0;
      return item.copyWith(
        unitPrice: newPrice ?? item.unitPrice,
        tintingCost: newTintingCost ?? item.tintingCost,
      );
    }).toList();
    state = state.copyWith(items: updatedItems);
  }

  // Tính toán đơn giá dựa trên bảng giá
  double? _calculateUnitPrice({required Product product, String? priceList}) {
    return product.prices[priceList] ?? product.basePrice;
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
  return QuoteNotifier(ref);
}, name: 'quoteProvider');

// Provider để tính tổng tiền của báo giá
final quoteTotalProvider = Provider<double>((ref) {
  final quoteItems = ref.watch(quoteProvider).items;
  if (quoteItems.isEmpty) return 0.0;
  return quoteItems.fold(0.0, (sum, item) => sum + item.totalPrice);
}, name: 'quoteTotalProvider');

// Provider cho danh sách các bảng giá
final priceListsProvider = Provider<List<String>>((ref) {
  return ['Giá bán lẻ', 'Giá đại lý cấp 1', 'Giá dự án'];
}, name: 'priceListsProvider');

// --- Các provider suy ra từ `quoteProvider` ---

// Provider cho khách hàng đã chọn, lấy từ báo giá hiện tại
final selectedCustomerProvider = Provider<Customer?>(
  (ref) => ref.watch(quoteProvider).customer,
  name: 'selectedCustomerProvider',
);

// Provider cho bảng giá đã chọn, lấy từ báo giá hiện tại
final selectedPriceListProvider = Provider<String?>(
  (ref) => ref.watch(quoteProvider).priceList,
  name: 'selectedPriceListProvider',
);
