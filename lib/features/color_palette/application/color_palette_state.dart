import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_paint_store_app/features/color_palette/domain/color_tone_helper.dart';
import 'package:flutter_paint_store_app/models/paint_color.dart';

// In a real app, you would fetch this from a remote source like Firestore.
List<PaintColor> _generateMockColors() {
  return [
    const PaintColor(
      id: '1',
      name: 'Trắng Sứ',
      code: 'AP01',
      brand: 'Mykolor',
      collection: 'Passion',
      color: Color(0xFFF5F5DC),
      ncs: 'S 0502-Y',
    ),
    const PaintColor(
      id: '2',
      name: 'Xanh Bạc Hà',
      code: 'AP25',
      brand: 'Mykolor',
      collection: 'Passion',
      color: Color(0xFF98FF98),
      ncs: 'S 1020-G10Y',
    ),
    const PaintColor(
      id: '3',
      name: 'Vàng Kem',
      code: 'AP15',
      brand: 'Mykolor',
      collection: 'Touch',
      color: Color(0xFFFFFDD0),
    ),
    const PaintColor(
      id: '4',
      name: 'Hồng Phấn',
      code: 'AP33',
      brand: 'Spec',
      collection: 'Hello',
      color: Color(0xFFFFD1DC),
      ncs: 'S 0515-R',
    ),
    const PaintColor(
      id: '5',
      name: 'Xám Ghi',
      code: 'AP50',
      brand: 'Spec',
      collection: 'Hello',
      color: Color(0xFF808080),
    ),
    const PaintColor(
      id: '6',
      name: 'Xanh Thiên Thanh',
      code: 'AP28',
      brand: 'Mykolor',
      collection: 'Touch',
      color: Color(0xFF87CEEB),
      ncs: 'S 1040-B',
    ),
    const PaintColor(
      id: '7',
      name: 'Đỏ Ruby',
      code: 'AP40',
      brand: 'Jotun',
      collection: 'Majestic',
      color: Color(0xFFE0115F),
    ),
    const PaintColor(
      id: '8',
      name: 'Tím Oải Hương',
      code: 'AP61',
      brand: 'Jotun',
      collection: 'Essence',
      color: Color(0xFFE6E6FA),
      ncs: 'S 1020-R70B',
    ),
    const PaintColor(
      id: '9',
      name: 'Cam San Hô',
      code: 'AP18',
      brand: 'Mykolor',
      collection: 'Passion',
      color: Color(0xFFFF7F50),
    ),
    const PaintColor(
      id: '10',
      name: 'Nâu Chocolate',
      code: 'AP75',
      brand: 'Jotun',
      collection: 'Majestic',
      color: Color(0xFFD2691E),
      ncs: 'S 6030-Y70R',
    ),
    const PaintColor(
      id: '11',
      name: 'Xanh Cổ Vịt',
      code: 'AP29',
      brand: 'Spec',
      collection: 'Go Green',
      color: Color(0xFF008080),
    ),
    const PaintColor(
      id: '12',
      name: 'Beige Cát',
      code: 'AP05',
      brand: 'Spec',
      collection: 'Hello',
      color: Color(0xFFF5F5DC),
    ),
  ];
}

// 1. Provider for the search query
final colorSearchQueryProvider = StateProvider<String>((ref) => '');

// 2. Provider to fetch all colors (currently mocked)
final allColorsProvider = Provider<List<PaintColor>>((ref) {
  // In a real app, this would be a FutureProvider fetching from Firestore
  return _generateMockColors();
});

// 3. Filter State Providers
final selectedBrandProvider = StateProvider<String?>((ref) => null);
final selectedCollectionProvider = StateProvider<String?>((ref) => null);
final selectedColorToneProvider = StateProvider<ColorTone?>((ref) => null);

// 4. Providers for filter options
final brandsProvider = Provider<List<String>>((ref) {
  final allColors = ref.watch(allColorsProvider);
  // Use a Set to get unique brand names, then convert to a list.
  return allColors.map((c) => c.brand).toSet().toList()..sort();
});

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

final colorTonesProvider = Provider<List<ColorTone>>((ref) {
  // Provides all available color tones for the filter UI.
  return ColorTone.values.toList();
});

// 5. Provider for the final filtered list of colors
final filteredColorsProvider = Provider<List<PaintColor>>((ref) {
  final query = ref.watch(colorSearchQueryProvider).toLowerCase();
  final allColors = ref.watch(allColorsProvider);
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

  return filteredByTone.toList();
});
