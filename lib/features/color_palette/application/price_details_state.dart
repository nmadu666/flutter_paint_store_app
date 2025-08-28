import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_paint_store_app/models/cost_item.dart';
import 'package:flutter_paint_store_app/models/parent_product.dart';

// 1. State Class
@immutable
class PriceDetailsState {
  const PriceDetailsState({
    this.items = const [],
    this.availablePriceLists = const [],
    this.selectedPriceList,
  });

  final List<CostItem> items;
  final List<String> availablePriceLists;
  final String? selectedPriceList;

  double get totalBasePrice => items.fold(0, (sum, item) => sum + item.totalBasePrice);
  double get totalDiscount => items.fold(0, (sum, item) => sum + item.discountAmount);
  double get totalTintCost => items.fold(0, (sum, item) => sum + item.totalTintCost);
  double get grandTotal => totalBasePrice + totalTintCost - totalDiscount;

  PriceDetailsState copyWith({
    List<CostItem>? items,
    List<String>? availablePriceLists,
    // Use ValueGetter to allow explicit null assignment
    ValueGetter<String?>? selectedPriceList,
  }) {
    return PriceDetailsState(
      items: items ?? this.items,
      availablePriceLists: availablePriceLists ?? this.availablePriceLists,
      selectedPriceList: selectedPriceList != null ? selectedPriceList() : this.selectedPriceList,
    );
  }
}

// 2. StateNotifier
class PriceDetailsStateNotifier extends StateNotifier<PriceDetailsState> {
  PriceDetailsStateNotifier(this.ref) : super(const PriceDetailsState());
  final Ref ref;

  void initItems(List<CostItem> initialItems, ParentProduct product) {
    final priceLists = <String>{};
    // Get price lists from ALL children, not just the selected ones,
    // so the dropdown is complete.
    for (final sku in product.children) {
      priceLists.addAll(sku.prices.keys);
    }

    state = state.copyWith(
      items: initialItems, // Use the items passed from the previous screen
      availablePriceLists: priceLists.toList()..sort(),
      selectedPriceList: () => null,
    );
  }

  void selectPriceList(String? priceListName) {
    final newItems = state.items.map((item) {
      final newUnitPrice = priceListName != null
          ? item.product.prices[priceListName] ?? item.product.basePrice
          : item.product.basePrice;
      return item.copyWith(unitPrice: newUnitPrice);
    }).toList();

    state = state.copyWith(items: newItems, selectedPriceList: () => priceListName);
  }

  void updateQuantity(String productId, int quantity) {
    state = state.copyWith(
      items: [
        for (final item in state.items)
          if (item.product.id == productId)
            item.copyWith(quantity: quantity)
          else
            item,
      ],
    );
  }

   void updateDiscount(String productId, double discount) {
     state = state.copyWith(
      items: [
        for (final item in state.items)
          if (item.product.id == productId)
            item.copyWith(discount: discount)
          else
            item,
      ],
    );
  }

  void setDiscountType(String productId, bool isPercent) {
     state = state.copyWith(
      items: [
        for (final item in state.items)
          if (item.product.id == productId)
            item.copyWith(isDiscountInPercent: isPercent)
          else
            item,
      ],
    );
  }
}

// 3. Provider
final priceDetailsProvider = StateNotifierProvider.autoDispose<PriceDetailsStateNotifier, PriceDetailsState>((ref) {
  return PriceDetailsStateNotifier(ref);
});
