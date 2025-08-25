import 'dart:convert';

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
import 'package:flutter_paint_store_app/features/sales/infrastructure/quote_local_storage_service.dart';

// --- UI State Providers ---

final salesSearchQueryProvider = StateProvider<String>((ref) => '', name: 'salesSearchQueryProvider');
final isShowingCartMobileProvider = StateProvider<bool>((ref) => false, name: 'isShowingCartMobileProvider');
final isPrintingProvider = StateProvider<bool>((ref) => false, name: 'isPrintingProvider');

// --- Data Providers ---

final salesProductsProvider = FutureProvider<List<Product>>((ref) async {
  await Future.delayed(const Duration(milliseconds: 300));
  return mockSalesProducts;
}, name: 'salesProductsProvider');

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

// --- In-Progress Quotes Management ---

final quoteLocalStorageServiceProvider = Provider((ref) => QuoteLocalStorageService());

final inProgressQuotesProvider = StateNotifierProvider<InProgressQuotesNotifier, List<Quote>>((ref) {
  return InProgressQuotesNotifier(ref);
});

class InProgressQuotesNotifier extends StateNotifier<List<Quote>> {
  InProgressQuotesNotifier(this.ref) : super([]) {
    _loadQuotes();
  }

  final Ref ref;

  Future<void> _loadQuotes() async {
    final quotes = await ref.read(quoteLocalStorageServiceProvider).loadQuotes();
    if (quotes.isEmpty) {
      _createNewQuote();
    } else {
      state = quotes;
    }
  }

  void _saveQuotes() {
    ref.read(quoteLocalStorageServiceProvider).saveQuotes(state);
  }

  void _createNewQuote() {
    final newQuote = Quote(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      items: [],
      createdAt: DateTime.now(),
    );
    state = [...state, newQuote];
    ref.read(activeQuoteIndexProvider.notifier).state = state.length - 1;
    _saveQuotes();
  }

  void addQuote() {
    _createNewQuote();
  }

  void removeQuote(int index) {
    if (state.length > 1) {
      state = [
        for (int i = 0; i < state.length; i++)
          if (i != index) state[i],
      ];
      final activeIndex = ref.read(activeQuoteIndexProvider);
      if (activeIndex >= index) {
        ref.read(activeQuoteIndexProvider.notifier).state = (activeIndex - 1).clamp(0, state.length - 1);
      }
      _saveQuotes();
    }
  }

  void _updateQuote(int index, Quote quote) {
    final quotes = List<Quote>.from(state);
    quotes[index] = quote;
    state = quotes;
    _saveQuotes();
  }

  void addItem({
    required Product product,
    PaintColor? color,
    int quantity = 1,
  }) {
    final activeIndex = ref.read(activeQuoteIndexProvider);
    final activeQuote = state[activeIndex];

    final existingItem = activeQuote.items.firstWhereOrNull(
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
      final updatedQuote = activeQuote.copyWith(items: [...activeQuote.items, newItem]);
      _updateQuote(activeIndex, updatedQuote);
    }
  }

  void addCostItems(List<CostItem> costItems, PaintColor color) {
    final activeIndex = ref.read(activeQuoteIndexProvider);
    final activeQuote = state[activeIndex];

    final newQuoteItems = costItems.map((costItem) {
      final finalUnitPrice = costItem.unitPrice + costItem.tintCost - costItem.discount;

      return QuoteItem(
        id: DateTime.now().millisecondsSinceEpoch.toString() + costItem.product.id,
        product: costItem.product,
        color: color,
        quantity: costItem.quantity,
        unitPrice: finalUnitPrice,
        tintingCost: 0,
        discountValue: 0,
        isDiscountPercentage: false,
        note: '${color.code} ${color.name}',
      );
    }).toList();

    final updatedQuote = activeQuote.copyWith(items: [...activeQuote.items, ...newQuoteItems]);
    _updateQuote(activeIndex, updatedQuote);
  }

  void addDuplicateItem(QuoteItem item) {
    final activeIndex = ref.read(activeQuoteIndexProvider);
    final activeQuote = state[activeIndex];
    final newItem = item.copyWith(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
    );
    final updatedQuote = activeQuote.copyWith(items: [...activeQuote.items, newItem]);
    _updateQuote(activeIndex, updatedQuote);
  }

  void updateQuantity(String quoteItemId, int newQuantity) {
    final activeIndex = ref.read(activeQuoteIndexProvider);
    final activeQuote = state[activeIndex];
    final items = List<QuoteItem>.from(activeQuote.items);
    final itemIndex = items.indexWhere((item) => item.id == quoteItemId);

    if (itemIndex != -1) {
      if (newQuantity > 0) {
        items[itemIndex] = items[itemIndex].copyWith(quantity: newQuantity);
        final updatedQuote = activeQuote.copyWith(items: items);
        _updateQuote(activeIndex, updatedQuote);
      } else {
        removeItem(quoteItemId);
      }
    }
  }

  void removeItem(String quoteItemId) {
    final activeIndex = ref.read(activeQuoteIndexProvider);
    final activeQuote = state[activeIndex];
    final updatedQuote = activeQuote.copyWith(
      items: activeQuote.items.where((item) => item.id != quoteItemId).toList(),
    );
    _updateQuote(activeIndex, updatedQuote);
  }

  void updateUnitPrice(String quoteItemId, double newUnitPrice) {
    final activeIndex = ref.read(activeQuoteIndexProvider);
    final activeQuote = state[activeIndex];
    final items = List<QuoteItem>.from(activeQuote.items);
    final itemIndex = items.indexWhere((item) => item.id == quoteItemId);

    if (itemIndex != -1) {
      items[itemIndex] = items[itemIndex].copyWith(unitPrice: newUnitPrice);
      final updatedQuote = activeQuote.copyWith(items: items);
      _updateQuote(activeIndex, updatedQuote);
    }
  }

  void applyDiscount(String quoteItemId, double value, bool isPercentage) {
    final activeIndex = ref.read(activeQuoteIndexProvider);
    final activeQuote = state[activeIndex];
    final items = List<QuoteItem>.from(activeQuote.items);
    final itemIndex = items.indexWhere((item) => item.id == quoteItemId);

    if (itemIndex != -1) {
      items[itemIndex] = items[itemIndex].copyWith(
        discountValue: value,
        isDiscountPercentage: isPercentage,
      );
      final updatedQuote = activeQuote.copyWith(items: items);
      _updateQuote(activeIndex, updatedQuote);
    }
  }

  void updateNote(String quoteItemId, String note) {
    final activeIndex = ref.read(activeQuoteIndexProvider);
    final activeQuote = state[activeIndex];
    final items = List<QuoteItem>.from(activeQuote.items);
    final itemIndex = items.indexWhere((item) => item.id == quoteItemId);

    if (itemIndex != -1) {
      items[itemIndex] = items[itemIndex].copyWith(note: note);
      final updatedQuote = activeQuote.copyWith(items: items);
      _updateQuote(activeIndex, updatedQuote);
    }
  }

  void updateAllPrices() {
    final activeIndex = ref.read(activeQuoteIndexProvider);
    final activeQuote = state[activeIndex];
    final newPriceList = ref.read(selectedPriceListProvider);
    final updatedItems = activeQuote.items.map((item) {
      final newPrice = _calculateUnitPrice(product: item.product, priceList: newPriceList);
      final newTintingCost = item.color != null ? _calculateTintingCost(item.product, item.color!) : 0.0;
      return item.copyWith(unitPrice: newPrice ?? item.unitPrice, tintingCost: newTintingCost ?? item.tintingCost);
    }).toList();
    final updatedQuote = activeQuote.copyWith(items: updatedItems);
    _updateQuote(activeIndex, updatedQuote);
  }

  double? _calculateUnitPrice({required Product product, String? priceList}) {
    final selectedPriceList = priceList ?? ref.read(selectedPriceListProvider);
    return product.prices[selectedPriceList] ?? product.basePrice;
  }

  double? _calculateTintingCost(Product product, PaintColor color) {
    final priceService = ref.read(priceServiceProvider);
    final finalPrice = priceService.getFinalPrice(color, product);
    if (finalPrice == null) {
      return null;
    }
    return finalPrice - product.basePrice;
  }

  void clear() {
    final activeIndex = ref.read(activeQuoteIndexProvider);
    final activeQuote = state[activeIndex];
    final updatedQuote = activeQuote.copyWith(items: [], customer: null);
    _updateQuote(activeIndex, updatedQuote);
  }

  void reorderItem(int oldIndex, int newIndex) {
    final activeIndex = ref.read(activeQuoteIndexProvider);
    final activeQuote = state[activeIndex];
    final items = List<QuoteItem>.from(activeQuote.items);
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final item = items.removeAt(oldIndex);
    items.insert(newIndex, item);
    final updatedQuote = activeQuote.copyWith(items: items);
    _updateQuote(activeIndex, updatedQuote);
  }
}

final activeQuoteIndexProvider = StateProvider<int>((ref) => 0, name: 'activeQuoteIndexProvider');

final quoteProvider = Provider<Quote>((ref) {
  final quotes = ref.watch(inProgressQuotesProvider);
  final activeIndex = ref.watch(activeQuoteIndexProvider);
  if (quotes.isEmpty || activeIndex >= quotes.length) {
    // Return a default/empty quote to avoid crashing
    return Quote(id: 'default', items: [], createdAt: DateTime.now());
  }
  return quotes[activeIndex];
}, name: 'quoteProvider');


final quoteTotalProvider = Provider<double>((ref) {
  final quoteItems = ref.watch(quoteProvider).items;
  if (quoteItems.isEmpty) return 0.0;
  return quoteItems.fold(0.0, (sum, item) => sum + item.totalPrice);
}, name: 'quoteTotalProvider');

final customersProvider = Provider<List<Customer>>((ref) {
  return [
    Customer(id: '1', name: 'Khách lẻ', phone: '', address: ''),
    Customer(id: '2', name: 'Anh Sơn - Cầu Giấy', phone: '', address: ''),
    Customer(id: '3', name: 'Công ty Xây dựng ABC', phone: '', address: ''),
  ];
}, name: 'customersProvider');

final selectedCustomerProvider = StateProvider<Customer?>((ref) {
    final activeQuote = ref.watch(quoteProvider);
  return activeQuote.customer ?? ref.watch(customersProvider).first;
}, name: 'selectedCustomerProvider');

final priceListsProvider = Provider<List<String>>((ref) {
  return ['Giá bán lẻ', 'Giá đại lý cấp 1', 'Giá dự án'];
}, name: 'priceListsProvider');

final selectedPriceListProvider = StateProvider<String?>((ref) {
  return ref.watch(priceListsProvider).first;
}, name: 'selectedPriceListProvider');