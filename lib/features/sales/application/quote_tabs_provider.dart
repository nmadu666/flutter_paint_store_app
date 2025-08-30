import 'dart:async';
import 'package:collection/collection.dart';
import 'package:flutter_paint_store_app/models/product.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_paint_store_app/models/cost_item.dart';
import 'package:flutter_paint_store_app/models/customer.dart';
import 'package:flutter_paint_store_app/models/paint_color.dart';
import 'package:flutter_paint_store_app/models/quote.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_paint_store_app/features/sales/infrastructure/quote_local_repository.dart';
import 'package:flutter_paint_store_app/features/sales/application/customer_providers.dart';

import 'price_book_providers.dart';

// State Definition
class SalesTabsState {
  final List<Quote> quotes;
  final int activeTabIndex;

  SalesTabsState({
    this.quotes = const [],
    this.activeTabIndex = 0,
  });

  Quote? get activeQuote =>
      quotes.isNotEmpty && activeTabIndex < quotes.length
          ? quotes[activeTabIndex]
          : null;

  SalesTabsState copyWith({
    List<Quote>? quotes,
    int? activeTabIndex,
  }) {
    return SalesTabsState(
      quotes: quotes ?? this.quotes,
      activeTabIndex: activeTabIndex ?? this.activeTabIndex,
    );
  }
}

// AsyncNotifier Definition
class QuoteTabsNotifier extends AsyncNotifier<SalesTabsState> {
  // Helper để lấy repository một cách an toàn.
  Future<QuoteLocalRepository> _getRepository() async {
    return ref.watch(quoteLocalRepositoryProvider.future);
  }

  @override
  Future<SalesTabsState> build() async {
    // 1. Sử dụng provider đã có để lấy repository.
    final repository = await _getRepository();
    final loadedQuotes = await repository.loadQuotes();

    if (loadedQuotes.isEmpty) {
      // 2. Lấy dữ liệu từ các provider bất đồng bộ một cách an toàn.
      final customers = ref.watch(customersProvider);
      final priceBooks = await ref.watch(priceBooksProvider.future);

      // 3. Tìm khách lẻ và bảng giá mặc định một cách an toàn.
      final retailCustomer = customers.firstWhereOrNull(
        (c) => c.id == retailCustomerId.toString(),
      );

      if (retailCustomer == null) {
        throw Exception(
            "Không tìm thấy khách lẻ. Vui lòng đồng bộ dữ liệu khách hàng.");
      }
      if (priceBooks.isEmpty) {
        throw Exception(
            "Không có bảng giá nào. Vui lòng đồng bộ dữ liệu bảng giá.");
      }

      final initialQuote = Quote.initial(0).copyWith(
        customer: retailCustomer,
        priceList: priceBooks.first.name, // Lấy tên của bảng giá đầu tiên
      );

      return SalesTabsState(
        quotes: [initialQuote],
        activeTabIndex: 0,
      );
    } else {
      return SalesTabsState(
        quotes: loadedQuotes,
        activeTabIndex: 0,
      );
    }
  }

  // 4. Áp dụng "Optimistic Update" để cải thiện UX.
  Future<void> _optimisticUpdateAndSave(SalesTabsState newState) async {
    // Cập nhật UI ngay lập tức, không cần chờ đợi.
    state = AsyncValue.data(newState);
    // Lưu vào bộ nhớ trong nền.
    try {
      final repository = await _getRepository();
      await repository.saveQuotes(newState.quotes);
    } catch (e, s) {
      // Nếu có lỗi, có thể xử lý bằng cách đưa state về trạng thái lỗi.
      state = AsyncValue.error('Lưu báo giá thất bại: $e', s);
    }
  }

  Future<void> addTab() async {
    if (state.value == null || state.value!.quotes.length >= 20) return;
    final currentState = state.value!;
    // Lấy dữ liệu an toàn khi thêm tab mới.
    final customers = ref.read(customersProvider);
    final priceBooks = await ref.read(priceBooksProvider.future);
    final retailCustomer =
        customers.firstWhereOrNull((c) => c.id == retailCustomerId.toString());

    if (retailCustomer == null || priceBooks.isEmpty) return;

    final newQuote = Quote.initial(currentState.quotes.length).copyWith(
      customer: retailCustomer,
      priceList: priceBooks.first.name,
    );
    final updatedQuotes = [...currentState.quotes, newQuote];
    await _optimisticUpdateAndSave(currentState.copyWith(
      quotes: updatedQuotes,
      activeTabIndex: updatedQuotes.length - 1,
    ));
  }

  Future<void> closeTab(int index) async {
    if (state.value == null || state.value!.quotes.length <= 1) return;
    final currentState = state.value!;
    final updatedQuotes = [...currentState.quotes]..removeAt(index);
    int newActiveIndex = currentState.activeTabIndex;
    if (index == currentState.activeTabIndex) {
      newActiveIndex = (index - 1).clamp(0, updatedQuotes.length - 1);
    } else if (index < currentState.activeTabIndex) {
      newActiveIndex = currentState.activeTabIndex - 1;
    }
    await _optimisticUpdateAndSave(currentState.copyWith(
      quotes: updatedQuotes,
      activeTabIndex: newActiveIndex,
    ));
  }

  void setActiveTab(int index) {
    if (state.value == null) return;
    final currentState = state.value!;
    if (index >= 0 && index < currentState.quotes.length) {
      state = AsyncValue.data(currentState.copyWith(activeTabIndex: index));
    }
  }

  Future<void> _mutateActiveQuote(Quote Function(Quote) mutation) async {
    if (state.value == null || state.value!.activeQuote == null) return;
    final currentState = state.value!;
    final activeQuote = currentState.activeQuote!;
    final updatedQuote = mutation(activeQuote);
    final updatedQuotes = [...currentState.quotes];
    updatedQuotes[currentState.activeTabIndex] = updatedQuote;
    await _optimisticUpdateAndSave(currentState.copyWith(quotes: updatedQuotes));
  }

  Future<void> addOrUpdateProduct(Product product) async {
    await _mutateActiveQuote((quote) {
      final existingItem = quote.items.firstWhereOrNull(
        (item) => item.product.id == product.id && item.color == null,
      );

      if (existingItem != null) {
        // If item exists, update its quantity and return the updated quote
        return quote.copyWith(items: quote.items.map((item) => item.id == existingItem.id ? existingItem.copyWith(quantity: existingItem.quantity + 1) : item).toList());
      } else {
        // If item does not exist, add it as a new item
        final unitPrice = product.prices[quote.priceList] ?? product.basePrice;
        final newItem = QuoteItem(
          id: const Uuid().v4(),
          product: product,
          quantity: 1,
          unitPrice: unitPrice,
        );
        return quote.copyWith(items: [...quote.items, newItem]);
      }
    });
  }

  Future<void> addCostItems(List<CostItem> costItems, PaintColor color) async {
    await _mutateActiveQuote((quote) {
      final newQuoteItems = costItems.map((costItem) {
        return QuoteItem(
          id: const Uuid().v4(),
          product: costItem.product,
          color: color,
          quantity: costItem.quantity,
          unitPrice: costItem.unitPrice,
          tintingCost: costItem.tintCost,
          discount: costItem.discount,
          discountIsPercentage: false,
          note: '${color.code} ${color.name}',
        );
      }).toList();
      return quote.copyWith(items: [...quote.items, ...newQuoteItems]);
    });
  }

  Future<void> updateItem(QuoteItem updatedItem) async {
    await _mutateActiveQuote((quote) {
      final updatedItems = quote.items.map((item) {
        return item.id == updatedItem.id ? updatedItem : item;
      }).toList();
      return quote.copyWith(items: updatedItems);
    });
  }

  Future<void> removeItem(String itemId) async {
    await _mutateActiveQuote((quote) {
      final updatedItems = quote.items.where((item) => item.id != itemId).toList();
      return quote.copyWith(items: updatedItems);
    });
  }

  Future<void> addDuplicateItem(QuoteItem item) async {
    await _mutateActiveQuote((quote) {
      final newItem = item.copyWith(id: const Uuid().v4());
      return quote.copyWith(items: [...quote.items, newItem]);
    });
  }

  Future<void> reorderItem(int oldIndex, int newIndex) async {
    await _mutateActiveQuote((quote) {
      if (oldIndex < newIndex) newIndex -= 1;
      final items = [...quote.items];
      final item = items.removeAt(oldIndex);
      items.insert(newIndex, item);
      return quote.copyWith(items: items);
    });
  }

  Future<void> updateCustomerForActiveQuote(Customer? customer) async {
    await _mutateActiveQuote((quote) => quote.copyWith(customer: customer));
  }

  Future<void> updatePriceListForActiveQuote(String? priceList) async {
    await _mutateActiveQuote((quote) {
      final updatedItems = quote.items.map((item) {
        final newUnitPrice = item.product.prices[priceList] ?? item.product.basePrice;
        return item.copyWith(unitPrice: newUnitPrice);
      }).toList();

      return quote.copyWith(
        items: updatedItems,
        priceList: priceList,
      );
    });
  }
}

final quoteTabsProvider = AsyncNotifierProvider<QuoteTabsNotifier, SalesTabsState>(() {
  return QuoteTabsNotifier();
});

// --- Derived Providers from Active Quote ---

final activeQuoteProvider = Provider<Quote?>((ref) {
  final asyncState = ref.watch(quoteTabsProvider);
  return asyncState.value?.activeQuote;
});

final activeQuoteSubtotalProvider = Provider.autoDispose<double>((ref) {
  final items = ref.watch(activeQuoteProvider)?.items ?? [];
  return items.fold<double>(0.0, (sum, item) => sum + item.subtotal);
});

final activeQuoteTotalDiscountProvider = Provider.autoDispose<double>((ref) {
  final items = ref.watch(activeQuoteProvider)?.items ?? [];
  return items.fold<double>(0.0, (sum, item) => sum + item.totalDiscountAmount);
});

final activeQuoteTotalProvider = Provider.autoDispose<double>((ref) {
  final items = ref.watch(activeQuoteProvider)?.items ?? [];
  return items.fold<double>(0.0, (sum, item) => sum + item.totalPrice);
});

final activeSelectedCustomerProvider = Provider<Customer?>(
  (ref) => ref.watch(activeQuoteProvider)?.customer,
);

final activeSelectedPriceListProvider = Provider<String?>(
  (ref) => ref.watch(activeQuoteProvider)?.priceList,
);
