import 'package:flutter/material.dart';
import '../models/paint_color.dart';
import '../models/paint_color_price.dart';
import '../models/parent_product.dart';
import '../models/product.dart';

// --- MOCK DATA ---

// ===========================================================================
// 1. Raw Data - The basic building blocks for our mock store
// ===========================================================================

/// All available paint colors in the system.
final List<PaintColor> mockAllColors = [
  PaintColor(id: '1', name: 'Trắng Sứ', code: 'AP01-1', brand: 'Jotun', collection: 'Majestic', color: const Color(0xFFF8F8F8)),
  PaintColor(id: '2', name: 'Vàng Chanh', code: 'AP02-3', brand: 'Jotun', collection: 'Majestic', color: const Color(0xFFFFF59D)),
  PaintColor(id: '3', name: 'Xanh Bạc Hà', code: 'AP03-2', brand: 'Dulux', collection: 'Weathershield', color: const Color(0xFFB2DFDB)),
  PaintColor(id: '4', name: 'Hồng Phấn', code: 'AP04-1', brand: 'Dulux', collection: 'Ambiance 5-in-1', color: const Color(0xFFFFCDD2)),
  PaintColor(id: '5', name: 'Xám Ghi', code: 'AP05-4', brand: 'Jotun', collection: 'Gardex', color: const Color(0xFFBDBDBD), ncs: 'S2000-N'),
  PaintColor(id: '6', name: 'Xanh Dương Đậm', code: 'AP06-5', brand: 'Dulux', collection: 'Weathershield', color: const Color(0xFF1A237E), ncs: 'S7020-R90B'),
  PaintColor(id: '7', name: 'Kem Bơ', code: 'AP07-1', brand: 'Jotun', collection: 'Majestic', color: const Color(0xFFFFF9C4)),
  PaintColor(id: '8', name: 'Xanh Lá Cây', code: 'AP08-3', brand: 'Dulux', collection: 'EasyClean', color: const Color(0xFF4CAF50)),
  PaintColor(id: '9', name: 'Đỏ Đô', code: 'AP09-5', brand: 'Jotun', collection: 'Gardex', color: const Color(0xFFB71C1C)),
  PaintColor(id: '10', name: 'Tím Lavender', code: 'AP10-2', brand: 'Dulux', collection: 'Ambiance 5-in-1', color: const Color(0xFFD1C4E9)),
  PaintColor(id: '11', name: 'Cam San Hô', code: 'AP11-3', brand: 'Jotun', collection: 'Majestic', color: const Color(0xFFFF8A65)),
  PaintColor(id: '12', name: 'Đen Mịn', code: 'AP12-6', brand: 'Dulux', collection: 'Weathershield', color: const Color(0xFF212121)),
];

/// Parent products that require color tinting.
/// These are not sold directly, but their children (bases) are.
final List<ParentProduct> mockParentProducts = [
  ParentProduct(
    id: 'jotun-majestic',
    name: 'Jotun Majestic',
    brand: 'Jotun',
    category: 'Sơn nội thất',
    tintingFormulaType: 'int_1', // Matches prices in mockColorPrices
    children: [
      Product(id: 'JM-A-1', name: 'Jotun Majestic - Base A', code: 'JMA1', unit: 'Lon', base: 'A', unitValue: 1, basePrice: 100000),
      Product(id: 'JM-A-5', name: 'Jotun Majestic - Base A', code: 'JMA5', unit: 'Lon', base: 'A', unitValue: 5, basePrice: 450000),
      Product(id: 'JM-D-1', name: 'Jotun Majestic - Base D', code: 'JMD1', unit: 'Lon', base: 'D', unitValue: 1, basePrice: 95000),
    ],
  ),
  ParentProduct(
    id: 'dulux-weathershield',
    name: 'Dulux Weathershield',
    brand: 'Dulux',
    category: 'Sơn ngoại thất',
    tintingFormulaType: 'ext_1', // Matches prices in mockColorPrices
    children: [
      Product(id: 'DW-A-5', name: 'Dulux Weathershield - Base A', code: 'DWA5', unit: 'Thùng', base: 'A', unitValue: 5, basePrice: 600000),
      Product(id: 'DW-B-5', name: 'Dulux Weathershield - Base B', code: 'DWB5', unit: 'Thùng', base: 'B', unitValue: 5, basePrice: 580000),
    ],
  ),
  ParentProduct(
    id: 'dulux-ambiance',
    name: 'Dulux Ambiance 5-in-1',
    brand: 'Dulux',
    category: 'Sơn nội thất cao cấp',
    tintingFormulaType: 'int_2', // Matches prices in mockColorPrices
    children: [
      Product(id: 'DA-C-5', name: 'Dulux Ambiance 5-in-1 - Base C', code: 'DA5C', unit: 'Lon', base: 'C', unitValue: 5, basePrice: 750000),
    ],
  ),
];

/// Standalone products that are sold as-is (no color tinting).
final List<Product> mockStandaloneProducts = [
    Product(
      id: 'JS-Primer-18',
      code: 'VT002',
      name: 'Sơn Lót Chống Kiềm Nội Thất Jotun',
      basePrice: 220000,
      unit: 'Thùng',
      unitValue: 18,
      prices: {
        'Giá bán lẻ': 220000,
        'Giá đại lý cấp 1': 200000,
        'Giá dự án': 190000,
      },
    ),
    Product(
      id: 'DP-Putty-40',
      code: 'VT005',
      name: 'Bột Trét Tường Ngoại Thất Dulux',
      basePrice: 100000,
      unit: 'Bao',
      unitValue: 40,
      prices: {
        'Giá bán lẻ': 100000,
        'Giá đại lý cấp 1': 90000,
        'Giá dự án': 85000,
      },
    ),
];


// ===========================================================================
// 2. Derived Data - Data created by combining or processing the raw data
// ===========================================================================

/// Pricing information for each color, based on the tinting formula and base.
final List<PaintColorPrice> mockColorPrices = [
  // Prices for 'Trắng Sứ' (AP01-1)
  PaintColorPrice.fromPaintColor(mockAllColors[0], tintingFormulaType: 'int_1', base: 'A', pricePerMl: 0.05),
  PaintColorPrice.fromPaintColor(mockAllColors[0], tintingFormulaType: 'ext_1', base: 'A', pricePerMl: 0.06),
  // Prices for 'Vàng Chanh' (AP02-3)
  PaintColorPrice.fromPaintColor(mockAllColors[1], tintingFormulaType: 'int_1', base: 'A', pricePerMl: 0.1),
  PaintColorPrice.fromPaintColor(mockAllColors[1], tintingFormulaType: 'ext_1', base: 'A', pricePerMl: 0.12),
  // Prices for 'Xanh Bạc Hà' (AP03-2)
  PaintColorPrice.fromPaintColor(mockAllColors[2], tintingFormulaType: 'ext_1', base: 'B', pricePerMl: 0.15),
  // Prices for 'Hồng Phấn' (AP04-1)
  PaintColorPrice.fromPaintColor(mockAllColors[3], tintingFormulaType: 'int_2', base: 'C', pricePerMl: 0.18),
  // Prices for 'Xanh Dương Đậm' (AP06-5)
  PaintColorPrice.fromPaintColor(mockAllColors[5], tintingFormulaType: 'ext_1', base: 'D', pricePerMl: 0.25), // Note: No 'D' base in mockParentProducts for ext_1, for testing purposes
  // Prices for 'Đỏ Đô' (AP09-5)
  PaintColorPrice.fromPaintColor(mockAllColors[8], tintingFormulaType: 'int_1', base: 'D', pricePerMl: 0.3),
];


/// A flat list of all individual products (SKUs) available for sale.
/// This is generated by combining the children of `mockParentProducts`
/// with `mockStandaloneProducts` and adding price lists.
final List<Product> mockSalesProducts = [
  // Products derived from ParentProducts (bases for tinting)
  ...mockParentProducts.expand((parent) {
    return parent.children.map((child) {
      // Create a copy of the child product to avoid modifying the original
      return Product(
        id: child.id,
        code: child.code,
        name: child.name,
        basePrice: child.basePrice,
        unit: child.unit,
        unitValue: child.unitValue,
        base: child.base,
        tintingFormulaType: parent.tintingFormulaType,
        // Add mock price tiers
        prices: {
          'Giá bán lẻ': child.basePrice,
          'Giá đại lý cấp 1': child.basePrice * 0.9,
          'Giá dự án': child.basePrice * 0.8,
        },
      );
    });
  }).toList(),

  // Standalone products (no tinting)
  ...mockStandaloneProducts,
];