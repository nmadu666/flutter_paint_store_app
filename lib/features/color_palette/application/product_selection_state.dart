import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_paint_store_app/features/color_palette/application/color_palette_state.dart';
import 'package:flutter_paint_store_app/models/paint_color.dart';
import 'package:flutter_paint_store_app/models/parent_product.dart';
import 'package:flutter_paint_store_app/models/product.dart';
import 'package:flutter_paint_store_app/models/cost_item.dart';

@immutable
class CostDetails {
  const CostDetails({
    required this.items,
    required this.totalCost,
    required this.totalBasePrice,
    required this.totalTintCost,
  });
  final List<CostItem> items;
  final double totalCost;
  final double totalBasePrice;
  final double totalTintCost;
}


@immutable
class SuitableChildrenRequest {
  const SuitableChildrenRequest({required this.parent, required this.color});
  final ParentProduct parent;
  final PaintColor color;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SuitableChildrenRequest &&
          runtimeType == other.runtimeType &&
          parent == other.parent &&
          color == other.color;

  @override
  int get hashCode => parent.hashCode ^ color.hashCode;
}

// --- State Providers for Product Selection Screen ---

final selectedCategoryProvider = StateProvider.autoDispose<String?>((ref) => null);

final selectedParentProductProvider = StateProvider.autoDispose<ParentProduct?>((ref) => null);

final currentColorProvider = Provider<PaintColor>((ref) => throw UnimplementedError());

final quantityProvider = StateProvider.autoDispose.family<int, String>(
  (ref, productId) => 0,
);

final categoriesProvider = Provider.autoDispose<List<String>>((ref) {
  final suitableParentsAsync = ref.watch(suitableParentProductsProvider(ref.watch(currentColorProvider)));
  return suitableParentsAsync.when(
    data: (products) => products.map((p) => p.category).toSet().toList()..sort(),
    loading: () => [],
    error: (_, __) => [],
  );
}, dependencies: [currentColorProvider]);

final filteredParentProductsProvider = Provider.autoDispose<List<ParentProduct>>((ref) {
  final suitableParentsAsync = ref.watch(suitableParentProductsProvider(ref.watch(currentColorProvider)));
  final category = ref.watch(selectedCategoryProvider);
  if (category == null) {
    return suitableParentsAsync.valueOrNull ?? [];
  }
  return suitableParentsAsync.valueOrNull?.where((p) => p.category == category).toList() ?? [];
}, dependencies: [currentColorProvider, selectedCategoryProvider]);

final suitableChildrenProvider = Provider.autoDispose.family<List<Product>, SuitableChildrenRequest>((ref, request) {
  final allColorPrices = ref.watch(allColorPricesProvider);

  return request.parent.children.where((child) {
    if (child.base == null || request.parent.tintingFormulaType == null) return false;

    final hasPriceInfo = allColorPrices.any(
      (price) =>
          price.code == request.color.code &&
          price.base == child.base &&
          price.tintingFormulaType == request.parent.tintingFormulaType,
    );
    return hasPriceInfo;
  }).toList();
});

final suitableBasesProvider = Provider.autoDispose.family<String, SuitableChildrenRequest>((ref, request) {
  final suitableChildren = ref.watch(suitableChildrenProvider(request));
  return suitableChildren.map((p) => p.base).whereType<String>().toSet().join(', ');
});

final costDetailsProvider = Provider.autoDispose<CostDetails>((ref) {
  final parent = ref.watch(selectedParentProductProvider);
  final color = ref.watch(currentColorProvider);
  if (parent == null) {
    return const CostDetails(
      items: [],
      totalCost: 0,
      totalBasePrice: 0,
      totalTintCost: 0,
    );
  }

  final suitableChildren =
      ref.watch(suitableChildrenProvider(SuitableChildrenRequest(parent: parent, color: color)));
  final List<CostItem> items = [];

  for (final child in suitableChildren) {
    final quantity = ref.watch(quantityProvider(child.id));
    if (quantity > 0) {
      final finalPrice = ref.watch(finalPriceProvider(ColorProductPair(color: color, product: child)));
      if (finalPrice != null) {
        final tintCost = finalPrice - child.basePrice;

        items.add(
          CostItem(
            product: child,
            quantity: quantity,
            basePrice: child.basePrice,
            tintCost: tintCost,
          ),
        );
      }
    }
  }

  final totalBasePrice = items.fold(0.0, (sum, item) => sum + item.totalBasePrice);
  final totalTintCost = items.fold(0.0, (sum, item) => sum + item.totalTintCost);
  final totalCost = items.fold(0.0, (sum, item) => sum + item.finalPrice);

  return CostDetails(
    items: items,
    totalCost: totalCost,
    totalBasePrice: totalBasePrice,
    totalTintCost: totalTintCost,
  );
}, dependencies: [selectedParentProductProvider, currentColorProvider]);