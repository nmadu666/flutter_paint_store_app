import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:collection/collection.dart';
import 'package:flutter_paint_store_app/features/color_palette/domain/color_tone_helper.dart';
import 'package:flutter_paint_store_app/models/paint_color.dart';
import 'package:flutter_paint_store_app/models/paint_color_price.dart';
import 'package:flutter_paint_store_app/models/parent_product.dart';
import 'package:flutter_paint_store_app/models/product.dart';

// --- 1. UI State Providers ---
// These providers manage the state of the UI, such as filters and search queries.

/// Manages the search query input by the user on the color palette screen.
final colorSearchQueryProvider = StateProvider<String>((ref) => '');

/// Manages the currently selected brand for filtering colors.
final selectedBrandProvider = StateProvider<String?>((ref) => null);

/// Manages the currently selected collection for filtering colors.
final selectedCollectionProvider = StateProvider<String?>((ref) => null);

/// Manages the currently selected color tone for filtering.
final selectedColorToneProvider = StateProvider<ColorTone?>((ref) => null);

// --- 2. Data Providers ---
// These providers are the source of truth for the app's data. In a real app,
// they would fetch data from a repository (e.g., Firestore, API) and would
// likely be FutureProviders or StreamProviders.

/// Provides the master list of all available paint colors.
final allColorsProvider = Provider<List<PaintColor>>((ref) {
  return _allColors;
});

/// Provides the master list of all parent products (product lines).
final allParentProductsProvider = FutureProvider<List<ParentProduct>>((
  ref,
) async {
  // Simulate network latency
  await Future.delayed(const Duration(milliseconds: 300));
  return _allParentProducts;
});

/// Provides the master list of all color pricing information.
final allColorPricesProvider = Provider<List<PaintColorPrice>>((ref) {
  final colors = ref.watch(allColorsProvider);
  // This mock data links a color to a formula type and base with a price.
  return _getMockColorPrices(colors);
});

// --- 3. Derived/Filtered Data Providers ---
// These providers compute new data based on the state of other providers.

// --- Filter Options ---

/// Provides a list of all unique brands from the color data for the filter UI.
final brandsProvider = Provider<List<String>>((ref) {
  final allColors = ref.watch(allColorsProvider);
  // Use a Set to get unique brand names, then convert to a list and sort.
  return allColors.map((c) => c.brand).toSet().toList()..sort();
});

/// Provides a list of collections, filtered by the selected brand, for the filter UI.
final collectionsProvider = Provider<List<String>>((ref) {
  final allColors = ref.watch(allColorsProvider);
  final selectedBrand = ref.watch(selectedBrandProvider);

  // If a brand is selected, show only collections from that brand.
  if (selectedBrand != null) {
    return allColors
        .where((c) => c.brand == selectedBrand)
        .map((c) => c.collection)
        .toSet()
        .toList()
      ..sort();
  }

  // Otherwise, show all unique collections.
  return allColors.map((c) => c.collection).toSet().toList()..sort();
});

/// Provides all available color tones for the filter UI.
final colorTonesProvider = Provider<List<ColorTone>>((ref) {
  return ColorTone.values.toList();
});

// --- Main Filtered Lists ---

/// Provider for the final filtered list of colors to be displayed.
final filteredColorsProvider = Provider<List<PaintColor>>((ref) {
  // 1. Watch all filter states
  final allColors = ref.watch(allColorsProvider);
  final query = ref.watch(colorSearchQueryProvider).toLowerCase().trim();
  final brand = ref.watch(selectedBrandProvider);
  final collection = ref.watch(selectedCollectionProvider);
  final tone = ref.watch(selectedColorToneProvider);

  // 2. Apply filters sequentially
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

  // 3. Sort the final list from light to dark
  final sortedList = filteredByTone.toList()
    ..sort((a, b) => b.lightness.compareTo(a.lightness));

  return sortedList;
});

/// Provider that returns a list of parent products that are suitable for a given color.
/// A product is suitable if:
/// - It belongs to the selected brand (if any).
/// - It has at least one tintable child product that is appropriate for the color.
final suitableParentProductsProvider = FutureProvider.autoDispose
    .family<List<ParentProduct>, PaintColor>((ref, color) async {
      // 1. Get all necessary data from other providers.
      final allParentProducts = await ref.watch(
        allParentProductsProvider.future,
      );
      final allColorPrices = ref.watch(allColorPricesProvider);
      final selectedBrand = ref.watch(selectedBrandProvider);

      // 2. Filter parent products by the selected brand, if any.
      final brandFilteredProducts = selectedBrand == null
          ? allParentProducts
          : allParentProducts.where((p) => p.brand == selectedBrand);

      // 3. Further filter to find parents with at least one suitable child product.
      final suitableParents = brandFilteredProducts.where((parent) {
        // A parent is suitable if ANY of its children are suitable.
        return parent.children.any((child) {
          // A child is suitable if:
          // a) It's tintable (has a base and the parent has a formula type).
          if (child.base == null || parent.tintingFormulaType == null) {
            return false;
          }
          // b) The base is physically suitable for the color's lightness.
          final isBasePhysicallySuitable = isBaseSuitableForColor(
            child.base!,
            color,
          );
          // c) A price definition exists for the specific color/formula/base combination.
          final hasPriceInfo = allColorPrices.any(
            (price) =>
                price.code == color.code &&
                price.base == child.base &&
                price.tintingFormulaType == parent.tintingFormulaType,
          );

          return isBasePhysicallySuitable && hasPriceInfo;
        });
      }).toList();

      // Sort the final list by name for consistent display.
      suitableParents.sort((a, b) => a.name.compareTo(b.name));

      return suitableParents;
    });

/// A simple tuple-like class to use as a key for the price provider family.
@immutable
// --- 4. Price Calculation ---
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

/// Calculates the final price for a given color and product combination.
final finalPriceProvider = Provider.autoDispose
    .family<double?, ColorProductPair>((ref, pair) {
      final parent = ref
          .watch(allParentProductsProvider)
          .value
          ?.firstWhereOrNull(
            (p) => p.children.any((child) => child.id == pair.product.id),
          );

      // Non-tintable products just have a base price.
      if (parent?.tintingFormulaType == null || pair.product.base == null) {
        return pair.product.basePrice;
      }

      final allColorPrices = ref.watch(allColorPricesProvider);

      // Find the specific price per ml for this combination
      final colorPrice = allColorPrices.firstWhereOrNull(
        (price) =>
            price.code == pair.color.code &&
            price.base == pair.product.base &&
            price.tintingFormulaType == parent?.tintingFormulaType,
      );

      if (colorPrice == null)
        return null; // No price defined for this combination

      // unitValue is in Liters, pricePerMl is per milliliter. 1L = 1000ml.
      final tintingCost = colorPrice.pricePerMl * pair.product.unitValue * 1000;
      return pair.product.basePrice + tintingCost;
    });

// --- 5. UI Interaction State ---

/// Manages the quantity for each child product in the selection sheet.
/// Defaults to 0, meaning nothing is selected initially.
final quantityProvider = StateProvider.autoDispose.family<int, String>(
  (ref, productId) => 0,
);

// =============================================================================
// --- Mock Data ---
// In a real application, this data would be fetched from a database or API.
// =============================================================================

final _allColors = [
  PaintColor(
    id: '1',
    name: 'Trắng Sứ',
    code: 'AP01-1',
    brand: 'Jotun',
    collection: 'Majestic',
    color: const Color(0xFFF8F8F8),
  ),
  PaintColor(
    id: '2',
    name: 'Vàng Chanh',
    code: 'AP02-3',
    brand: 'Jotun',
    collection: 'Majestic',
    color: const Color(0xFFFFF59D),
  ),
  PaintColor(
    id: '3',
    name: 'Xanh Bạc Hà',
    code: 'AP03-2',
    brand: 'Dulux',
    collection: 'Weathershield',
    color: const Color(0xFFB2DFDB),
  ),
  PaintColor(
    id: '4',
    name: 'Hồng Phấn',
    code: 'AP04-1',
    brand: 'Dulux',
    collection: 'Ambiance 5-in-1',
    color: const Color(0xFFFFCDD2),
  ),
  PaintColor(
    id: '5',
    name: 'Xám Ghi',
    code: 'AP05-4',
    brand: 'Jotun',
    collection: 'Gardex',
    color: const Color(0xFFBDBDBD),
    ncs: 'S2000-N',
  ),
  PaintColor(
    id: '6',
    name: 'Xanh Dương Đậm',
    code: 'AP06-5',
    brand: 'Dulux',
    collection: 'Weathershield',
    color: const Color(0xFF1A237E),
    ncs: 'S7020-R90B',
  ),
  PaintColor(
    id: '7',
    name: 'Kem Bơ',
    code: 'AP07-1',
    brand: 'Jotun',
    collection: 'Majestic',
    color: const Color(0xFFFFF9C4),
  ),
  PaintColor(
    id: '8',
    name: 'Xanh Lá Cây',
    code: 'AP08-3',
    brand: 'Dulux',
    collection: 'EasyClean',
    color: const Color(0xFF4CAF50),
  ),
  PaintColor(
    id: '9',
    name: 'Đỏ Đô',
    code: 'AP09-5',
    brand: 'Jotun',
    collection: 'Gardex',
    color: const Color(0xFFB71C1C),
  ),
  PaintColor(
    id: '10',
    name: 'Tím Lavender',
    code: 'AP10-2',
    brand: 'Dulux',
    collection: 'Ambiance 5-in-1',
    color: const Color(0xFFD1C4E9),
  ),
  PaintColor(
    id: '11',
    name: 'Cam San Hô',
    code: 'AP11-3',
    brand: 'Jotun',
    collection: 'Majestic',
    color: const Color(0xFFFF8A65),
  ),
  PaintColor(
    id: '12',
    name: 'Đen Mịn',
    code: 'AP12-6',
    brand: 'Dulux',
    collection: 'Weathershield',
    color: const Color(0xFF212121),
  ),
];

final _allParentProducts = [
  ParentProduct(
    id: 'jotun-majestic',
    name: 'Jotun Majestic',
    brand: 'Jotun',
    category: 'Sơn nội thất',
    children: [
      Product(
        id: '1',
        name: 'Jotun Majestic - Base A',
        code: 'JMA',
        unit: 'Lon',
        tintingFormulaType: 'int_1',
        base: 'A',
        unitValue: 1,
        basePrice: 100,
      ),
      Product(
        id: '2',
        name: 'Jotun Majestic - Base D',
        code: 'JMD',
        unit: 'Lon',
        tintingFormulaType: 'int_1',
        base: 'D',
        unitValue: 1,
        basePrice: 100,
      ),
    ],
  ),
  ParentProduct(
    id: 'dulux-weathershield',
    name: 'Dulux Weathershield',
    brand: 'Dulux',
    category: 'Sơn ngoại thất',
    children: [
      Product(
        id: '3',
        name: 'Dulux Weathershield - Base A',
        code: 'DWA',
        unit: 'Lon',
        tintingFormulaType: 'ext_1',
        base: 'A',
        unitValue: 1,
        basePrice: 120,
      ),
      Product(
        id: '4',
        name: 'Dulux Weathershield - Base B',
        code: 'DWB',
        unit: 'Lon',
        tintingFormulaType: 'ext_1',
        base: 'B',
        unitValue: 1,
        basePrice: 120,
      ),
    ],
  ),
  ParentProduct(
    id: 'dulux-ambiance',
    name: 'Dulux Ambiance 5-in-1',
    brand: 'Dulux',
    category: 'Sơn nội thất cao cấp',
    children: [
      Product(
        id: '5',
        name: 'Dulux Ambiance 5-in-1 - Base C',
        code: 'DA5C',
        unit: 'Lon',
        tintingFormulaType: 'int_2',
        base: 'C',
        unitValue: 1,
        basePrice: 150,
      ),
    ],
  ),
  ParentProduct(
    id: 'jotun-primer',
    name: 'Sơn lót chống kiềm',
    brand: 'Jotun',
    category: 'Sơn lót',
    children: [
      Product(
        id: '6',
        name: 'Sơn lót chống kiềm',
        code: 'JPL',
        unit: 'Lon',
        tintingFormulaType: null,
        base: null,
        unitValue: 5,
        basePrice: 80,
      ),
    ],
  ),
];

List<PaintColorPrice> _getMockColorPrices(List<PaintColor> colors) {
  return [
    // Prices for 'Trắng Sứ'
    PaintColorPrice.fromPaintColor(
      colors[0],
      tintingFormulaType: 'int_1',
      base: 'A',
      pricePerMl: 0.05,
    ),
    PaintColorPrice.fromPaintColor(
      colors[0],
      tintingFormulaType: 'ext_1',
      base: 'A',
      pricePerMl: 0.06,
    ),
    // Prices for 'Vàng Chanh'
    PaintColorPrice.fromPaintColor(
      colors[1],
      tintingFormulaType: 'int_1',
      base: 'A',
      pricePerMl: 0.1,
    ),
    PaintColorPrice.fromPaintColor(
      colors[1],
      tintingFormulaType: 'ext_1',
      base: 'A',
      pricePerMl: 0.12,
    ),
    // Prices for 'Xanh Bạc Hà'
    PaintColorPrice.fromPaintColor(
      colors[2],
      tintingFormulaType: 'ext_1',
      base: 'B',
      pricePerMl: 0.15,
    ),
    // Prices for 'Hồng Phấn'
    PaintColorPrice.fromPaintColor(
      colors[3],
      tintingFormulaType: 'int_2',
      base: 'C',
      pricePerMl: 0.18,
    ),
    // Prices for 'Xanh Dương Đậm'
    PaintColorPrice.fromPaintColor(
      colors[5],
      tintingFormulaType: 'ext_1',
      base: 'D',
      pricePerMl: 0.25,
    ),
    // Prices for 'Đỏ Đô'
    PaintColorPrice.fromPaintColor(
      colors[8],
      tintingFormulaType: 'int_1',
      base: 'D',
      pricePerMl: 0.3,
    ),
  ];
}
