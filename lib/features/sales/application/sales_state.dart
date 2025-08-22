import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_paint_store_app/features/color_palette/application/color_palette_state.dart';
import 'package:flutter_paint_store_app/models/customer.dart';
import 'package:collection/collection.dart'; // Import for firstWhereOrNull
import 'package:flutter_paint_store_app/models/paint_color.dart';
import 'package:flutter_paint_store_app/models/product.dart';
import 'package:flutter_paint_store_app/models/quote.dart';

// --- UI State Providers ---

final salesSearchQueryProvider = StateProvider<String>((ref) => '');
final isShowingCartMobileProvider = StateProvider<bool>((ref) => false);
final isPrintingProvider = StateProvider<bool>((ref) => false);

// --- Data Providers ---

/// Provides a flat list of all individual products (SKUs) available for sale.
/// This is derived from the central `allParentProductsProvider`.
final salesProductsProvider = FutureProvider<List<Product>>((ref) async {
  final parentProducts = await ref.watch(allParentProductsProvider.future);
  return parentProducts.expand((parent) => parent.children).toList();
});

/// Provides a filtered list of products based on the search query.
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

/// Manages the state of the current quote, including its items.
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

  /// Adds an item to the quote. If an item with the same product and color
  /// already exists, it increments the quantity.
  void addItem({
    required Product product,
    PaintColor? color,
    int quantity = 1,
  }) {
    final existingItemIndex = state.items.indexWhere(
      (item) => item.product.id == product.id && item.color?.id == color?.id,
    );

    if (existingItemIndex != -1) {
      // Item exists, just update its quantity
      final existingItem = state.items[existingItemIndex];
      updateQuantity(existingItem.id, existingItem.quantity + quantity);
    } else {
      // Item does not exist, create a new one
      final unitPrice = _calculateUnitPrice(product: product, color: color);
      if (unitPrice == null) {
        // Cannot determine price, do not add to cart.
        // Optionally, show an error to the user.
        return;
      }

      final newItem = QuoteItem(
        // Create a unique ID for the quote item
        id: '${product.id}_${color?.id ?? 'none'}_${Random().nextInt(99999)}',
        product: product,
        color: color,
        quantity: quantity,
        unitPrice: unitPrice,
      );
      state = state.copyWith(items: [...state.items, newItem]);
    }
  }

  void updateQuantity(String quoteItemId, int newQuantity) {
    final items = List<QuoteItem>.from(state.items);
    final itemIndex = items.indexWhere((item) => item.id == quoteItemId);

    if (itemIndex != -1) {
      if (newQuantity > 0) {
        items[itemIndex] = items[itemIndex].copyWith(quantity: newQuantity);
        state = state.copyWith(items: items);
      } else {
        // Remove item if quantity is 0 or less
        removeItem(quoteItemId);
      }
    }
  }

  void removeItem(String quoteItemId) {
    state = state.copyWith(
      items: state.items.where((item) => item.id != quoteItemId).toList(),
    );
  }

  /// Recalculates all prices in the cart. Useful when the price list changes.
  void updateAllPrices() {
    final newPriceList = ref.read(selectedPriceListProvider);
    final updatedItems = state.items.map((item) {
      final newPrice = _calculateUnitPrice(
        product: item.product,
        color: item.color,
        priceList: newPriceList,
      );
      return item.copyWith(unitPrice: newPrice ?? item.unitPrice);
    }).toList();
    state = state.copyWith(items: updatedItems);
  }

  /// Calculates the unit price for a given product and optional color.
  double? _calculateUnitPrice({
    required Product product,
    PaintColor? color,
    String? priceList,
  }) {
    final selectedPriceList = priceList ?? ref.read(selectedPriceListProvider);

    // Find the base price from the selected price list.
    // If a specific price group is found in the `prices` list, use it.
    // Otherwise, fall back to the product's `basePrice`.
    final specificPrice = product.prices.firstWhereOrNull(
      (p) => p.priceGroup == selectedPriceList,
    );

    final basePrice = specificPrice?.price ?? product.basePrice;

    // If it's not a tintable product, the price is just the base price.
    if (color == null || product.tintingFormulaType == null) {
      return basePrice;
    }

    // For tinted products, add the tinting cost.
    final colorPrice = ref
        .read(allColorPricesProvider)
        .firstWhereOrNull(
          (p) =>
              p.code == color.code &&
              p.base == product.base &&
              p.tintingFormulaType == product.tintingFormulaType,
        );

    if (colorPrice == null) {
      // Price not found for this specific combination of color/base/formula
      print(
        'Error: Price not found for color ${color.code}, base ${product.base}, formula ${product.tintingFormulaType}',
      );
      return null;
    }
    final tintingCost = colorPrice.pricePerMl * product.unitValue * 1000;
    return basePrice + tintingCost;
  }

  void clear() {
    state = state.copyWith(items: [], customer: null);
  }
}

// --- Quote Providers ---

final quoteProvider = StateNotifierProvider<QuoteNotifier, Quote>((ref) {
  final notifier = QuoteNotifier(ref);

  // When the price list changes, trigger a price update for all items in the cart.
  ref.listen<String>(selectedPriceListProvider, (previous, next) {
    if (previous != next) {
      notifier.updateAllPrices();
    }
  });

  return notifier;
});

/// Calculates the total price of the current quote.
final quoteTotalProvider = Provider<double>((ref) {
  final quoteItems = ref.watch(quoteProvider).items;
  if (quoteItems.isEmpty) return 0.0;
  return quoteItems.fold(0.0, (sum, item) => sum + item.totalPrice);
});

// --- Customer and Price List Providers ---

final customersProvider = Provider<List<Customer>>((ref) {
  // In a real app, fetch from Firestore
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
