import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_paint_store_app/data/mock_data.dart';
import 'package:flutter_paint_store_app/features/color_palette/application/color_palette_state.dart';
import 'package:flutter_paint_store_app/models/customer.dart';
import 'package:collection/collection.dart';
import 'package:flutter_paint_store_app/models/paint_color.dart';
import 'package:flutter_paint_store_app/models/product.dart';
import 'package:flutter_paint_store_app/models/quote.dart';
import 'price_calculation_service.dart';

// --- UI State Providers ---

final salesSearchQueryProvider = StateProvider<String>((ref) => '');
final isShowingCartMobileProvider = StateProvider<bool>((ref) => false);
final isPrintingProvider = StateProvider<bool>((ref) => false);

// --- Data Providers ---

final salesProductsProvider = FutureProvider<List<Product>>((ref) async {
  await Future.delayed(const Duration(milliseconds: 300));
  return mockSalesProducts;
});

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
});

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

  void addDuplicateItem(QuoteItem item) {
    final newItem = item.copyWith(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
    );
    state = state.copyWith(items: [...state.items, newItem]);
  }

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

  void removeItem(String quoteItemId) {
    state = state.copyWith(
      items: state.items.where((item) => item.id != quoteItemId).toList(),
    );
  }

  void updateUnitPrice(String quoteItemId, double newUnitPrice) {
    final items = List<QuoteItem>.from(state.items);
    final itemIndex = items.indexWhere((item) => item.id == quoteItemId);

    if (itemIndex != -1) {
      items[itemIndex] = items[itemIndex].copyWith(unitPrice: newUnitPrice);
      state = state.copyWith(items: items);
    }
  }

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

  void updateNote(String quoteItemId, String note) {
    final items = List<QuoteItem>.from(state.items);
    final itemIndex = items.indexWhere((item) => item.id == quoteItemId);

    if (itemIndex != -1) {
      items[itemIndex] = items[itemIndex].copyWith(note: note);
      state = state.copyWith(items: items);
    }
  }

  void updateAllPrices() {
    final newPriceList = ref.read(selectedPriceListProvider);
    final updatedItems = state.items.map((item) {
      final newPrice = _calculateUnitPrice(product: item.product, priceList: newPriceList);
      final newTintingCost = item.color != null ? _calculateTintingCost(item.product, item.color!) : 0.0;
      return item.copyWith(unitPrice: newPrice ?? item.unitPrice, tintingCost: newTintingCost ?? item.tintingCost);
    }).toList();
    state = state.copyWith(items: updatedItems);
  }

  double? _calculateUnitPrice({required Product product, String? priceList}) {
    final selectedPriceList = priceList ?? ref.read(selectedPriceListProvider);
    return product.prices[selectedPriceList] ?? product.basePrice;
  }

  double? _calculateTintingCost(Product product, PaintColor color) {
    final parentProduct = ref.read(allParentProductsProvider).value?.firstWhereOrNull((p) => p.children.any((child) => child.id == product.id));

    if (parentProduct == null || parentProduct.tintingFormulaType == null) {
        return 0.0;
    }

    final colorPrice = ref.read(allColorPricesProvider).firstWhereOrNull(
          (p) =>
              p.code == color.code &&
              p.base == product.base &&
              p.tintingFormulaType == parentProduct.tintingFormulaType,
        );

    if (colorPrice == null) {
      print(
        'Error: Price not found for color ${color.code}, base ${product.base}, formula ${parentProduct.tintingFormulaType}',
      );
      return null;
    }

    return calculateTintingCost(product, colorPrice);
  }

  void clear() {
    state = state.copyWith(items: [], customer: null);
  }

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

final quoteProvider = StateNotifierProvider<QuoteNotifier, Quote>((ref) {
  final notifier = QuoteNotifier(ref);

  ref.listen<String>(selectedPriceListProvider, (previous, next) {
    if (previous != next) {
      notifier.updateAllPrices();
    }
  });

  return notifier;
});

final quoteTotalProvider = Provider<double>((ref) {
  final quoteItems = ref.watch(quoteProvider).items;
  if (quoteItems.isEmpty) return 0.0;
  return quoteItems.fold(0.0, (sum, item) => sum + item.totalPrice);
});

final customersProvider = Provider<List<Customer>>((ref) {
  return [
    Customer(id: '1', name: 'Khách lẻ', phone: '', address: ''),
    Customer(id: '2', name: 'Anh Sơn - Cầu Giấy', phone: '', address: ''),
    Customer(id: '3', name: 'Công ty Xây dựng ABC', phone: '', address: ''),
  ];
});

final selectedCustomerProvider = StateProvider<Customer?>((ref) {
  return ref.watch(customersProvider).first;
});

final priceListsProvider = Provider<List<String>>((ref) {
  return ['Giá bán lẻ', 'Giá đại lý cấp 1', 'Giá dự án'];
});

final selectedPriceListProvider = StateProvider<String>((ref) {
  return ref.watch(priceListsProvider).first;
});
