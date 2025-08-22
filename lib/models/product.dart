import 'package:flutter/foundation.dart';
import 'package:flutter_paint_store_app/models/product_pricing.dart';

/// Represents a paint product available in the store.
@immutable
class Product {
  final String id;
  final String name;
  final String code;
  final String unit;

  /// The type of tinting formula to use (e.g., 'int_1', 'ext_1', 'sd').
  /// Null for non-tintable products.
  final String? tintingFormulaType;
  final String?
  base; // Nullable, as some products might not have a base (e.g., primer)
  /// The numeric value of the unit (e.g., 18 for an 18L can) used for tinting cost calculation.
  final double unitValue;

  /// The price of the base product before tinting.
  final double basePrice;

  /// List of prices for different price groups (e.g., retail, wholesale).
  final List<ProductPricing> prices;

  const Product({
    required this.id,
    required this.name,
    required this.code,
    required this.unit,
    this.tintingFormulaType,
    this.base,
    required this.unitValue,
    required this.basePrice,
    this.prices = const [],
  });

  /// Deserializes the given `Map<String, dynamic>` into a [Product].
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as String,
      name: json['name'] as String,
      code: json['code'] as String,
      unit: json['unit'] as String,
      tintingFormulaType: json['tintingFormulaType'] as String?,
      base: json['base'] as String?,
      unitValue: (json['unitValue'] as num).toDouble(),
      basePrice: (json['basePrice'] as num).toDouble(),
      prices: (json['prices'] as List<dynamic>?)
              ?.map((e) => ProductPricing.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );
  }

  /// Converts this [Product] into a `Map<String, dynamic>`.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'unit': unit,
      'tintingFormulaType': tintingFormulaType,
      'base': base,
      'unitValue': unitValue,
      'basePrice': basePrice,
      'prices': prices.map((e) => e.toJson()).toList(),
    };
  }

  Product copyWith({
    String? id,
    String? name,
    String? code,
    String? unit,
    String? tintingFormulaType,
    String? base,
    double? unitValue,
    double? basePrice,
    List<ProductPricing>? prices,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      code: code ?? this.code,
      unit: unit ?? this.unit,
      tintingFormulaType: tintingFormulaType ?? this.tintingFormulaType,
      base: base ?? this.base,
      unitValue: unitValue ?? this.unitValue,
      basePrice: basePrice ?? this.basePrice,
      prices: prices ?? this.prices,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Product &&
        other.id == id &&
        other.name == name &&
        other.code == code &&
        other.unit == unit &&
        other.tintingFormulaType == tintingFormulaType &&
        other.base == base &&
        other.unitValue == unitValue &&
        other.basePrice == basePrice &&
        listEquals(other.prices, prices);
  }

  @override
  int get hashCode {
    return id.hashCode ^
      name.hashCode ^
      code.hashCode ^
      unit.hashCode ^
      tintingFormulaType.hashCode ^
      base.hashCode ^
      unitValue.hashCode ^
      basePrice.hashCode ^
      prices.hashCode;
  }

  @override
  String toString() {
    return 'Product(id: $id, name: $name, code: $code, unit: $unit, tintingFormulaType: $tintingFormulaType, base: $base, unitValue: $unitValue, basePrice: $basePrice, prices: $prices)';
  }
}
