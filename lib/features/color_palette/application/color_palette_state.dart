import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_paint_store_app/features/color_palette/domain/color_tone_helper.dart';
import 'package:flutter_paint_store_app/models/paint_color.dart';
import 'package:flutter_paint_store_app/models/paint_color_price.dart';
import 'package:flutter_paint_store_app/models/parent_product.dart';
import 'package:flutter_paint_store_app/data/mock_data.dart';
import 'package:flutter_paint_store_app/models/product.dart';
import 'package:flutter_paint_store_app/features/sales/application/price_service.dart';

// --- 1. UI State Providers ---

final colorSearchQueryProvider = StateProvider<String>((ref) => '');
final selectedBrandProvider = StateProvider<String?>((ref) => null);
final selectedCollectionProvider = StateProvider<String?>((ref) => null);
final selectedColorToneProvider = StateProvider<ColorTone?>((ref) => null);

// --- 2. Data Providers ---

final allColorsProvider = Provider<List<PaintColor>>((ref) {
  return mockAllColors;
});

final allParentProductsProvider = FutureProvider<List<ParentProduct>>((
  ref,
) async {
  await Future.delayed(const Duration(milliseconds: 300));
  return mockParentProducts;
});

final allColorPricesProvider = Provider<List<PaintColorPrice>>((ref) {
  return mockColorPrices;
});

// --- 3. Derived/Filtered Data Providers ---

final brandsProvider = Provider<List<String>>((ref) {
  final allColors = ref.watch(allColorsProvider);
  return allColors.map((c) => c.brand).toSet().toList()..sort();
});

final collectionsProvider = Provider<List<String>>((ref) {
  final allColors = ref.watch(allColorsProvider);

  final selectedBrand = ref.watch(selectedBrandProvider);
  if (ref.watch(selectedBrandProvider) != null) {
    return allColors
        .where((c) => c.brand == selectedBrand)
        .map((c) => c.collection)
        .toSet()
        .toList()
      ..sort();
  }

  return allColors.map((c) => c.collection).toSet().toList()..sort();
});

final colorTonesProvider = Provider<List<ColorTone>>((ref) {
  return ColorTone.values.toList();
});

final filteredColorsProvider = Provider<List<PaintColor>>((ref) {
  final allColors = ref.watch(allColorsProvider);
  final query = ref.watch(colorSearchQueryProvider).toLowerCase().trim();
  final brand = ref.watch(selectedBrandProvider);
  final collection = ref.watch(selectedCollectionProvider);
  final tone = ref.watch(selectedColorToneProvider);

  final filteredByText = query.isEmpty
      ? allColors
      : allColors.where((color) {
          final ncsMatch = color.ncs?.toLowerCase().contains(query) ?? false;
          return color.name.toLowerCase().contains(query) ||
              color.code.toLowerCase().contains(query) ||
              color.hexString.toLowerCase().contains(query) ||
              color.brand.toLowerCase().contains(query) ||
              ncsMatch;
        });

  final filteredByBrand = brand == null
      ? filteredByText
      : filteredByText.where((c) => c.brand == brand);

  final filteredByCollection = collection == null
      ? filteredByBrand
      : filteredByBrand.where((c) => c.collection == collection);

  final filteredByTone = tone == null
      ? filteredByCollection
      : filteredByCollection.where((c) => getColorTone(c.color) == tone);

  final sortedList = filteredByTone.toList()
    ..sort((a, b) => b.lightness.compareTo(a.lightness));

  return sortedList;
});

final suitableParentProductsProvider = FutureProvider.autoDispose
    .family<List<ParentProduct>, PaintColor>((ref, color) async {
      final allParentProducts = await ref.watch(
        allParentProductsProvider.future,
      );
      final allColorPrices = ref.watch(allColorPricesProvider);

      // Filter products by the brand of the selected color
      final brandFilteredProducts = allParentProducts.where(
        (p) => p.brand == color.brand,
      );

      final suitableParents = brandFilteredProducts.where((parent) {
        // A parent product is suitable if it has ANY child product that can be tinted
        // with the selected color. Suitability is determined solely by price data.
        return parent.children.any((child) {
          if (child.base == null || parent.tintingFormulaType == null) {
            return false;
          }
          return allColorPrices.any(
            (price) =>
                price.code == color.code &&
                price.base == child.base &&
                price.tintingFormulaType == parent.tintingFormulaType,
          );
        });
      }).toList();

      suitableParents.sort((a, b) => a.name.compareTo(b.name));

      return suitableParents;
    });

@immutable
class ColorProductPair {
  const ColorProductPair({required this.color, required this.product});
  final PaintColor color;
  final Product product;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ColorProductPair &&
        other.color == color &&
        other.product == product;
  }

  @override
  int get hashCode => color.hashCode ^ product.hashCode;
}

final finalPriceProvider = Provider.autoDispose
    .family<double?, ColorProductPair>((ref, pair) {
      final priceService = ref.watch(priceServiceProvider);
      return priceService.getFinalPrice(pair.color, pair.product, [], []);
    });
