import 'package:equatable/equatable.dart';

/// Represents a single, sellable product SKU (Stock Keeping Unit).
class Product extends Equatable {
  const Product({
    required this.id,
    required this.code,
    required this.name,
    required this.basePrice,
    required this.unit,
    required this.unitValue,
    this.base,
    this.tintingFormulaType,
    this.prices = const {},
  });

  final String id;
  final String code;
  final String name;

  /// The default/fallback price when no specific price list price is found.
  final double basePrice;

  /// A map where the key is the price group name (e.g., "Giá bán lẻ")
  /// and the value is the price for that group.
  /// This allows for O(1) price lookups.
  final Map<String, double> prices;

  final String unit; // e.g., "Lít", "Kg"
  final double unitValue; // e.g., 1, 5, 18
  final String? base; // e.g., 'A', 'B', 'C' for paint base
  final String? tintingFormulaType; // e.g., 'DECO', 'PRO'

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as String,
      code: json['code'] as String,
      name: json['name'] as String,
      basePrice: (json['basePrice'] as num).toDouble(),
      unit: json['unit'] as String,
      unitValue: (json['unitValue'] as num).toDouble(),
      base: json['base'] as String?,
      tintingFormulaType: json['tintingFormulaType'] as String?,
      // Ensure prices are parsed correctly from JSON
      prices: Map<String, double>.from(
          (json['prices'] as Map<String, dynamic>?)?.map(
                (key, value) => MapEntry(key, (value as num).toDouble()),
              ) ??
              {}),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'code': code,
        'name': name,
        'basePrice': basePrice,
        'prices': prices,
        'unit': unit,
        'unitValue': unitValue,
        'base': base,
        'tintingFormulaType': tintingFormulaType,
      };

  Product copyWith({
    String? id,
    String? code,
    String? name,
    double? basePrice,
    Map<String, double>? prices,
    String? unit,
    double? unitValue,
    String? base,
    String? tintingFormulaType,
  }) {
    // For now, return a new instance with the same data
    return Product(
      id: id ?? this.id,
      code: code ?? this.code,
      name: name ?? this.name,
      basePrice: basePrice ?? this.basePrice,
      prices: prices ?? this.prices,
      unit: unit ?? this.unit,
      unitValue: unitValue ?? this.unitValue,
      base: base ?? this.base,
      tintingFormulaType: tintingFormulaType ?? this.tintingFormulaType,
    );
  }

  @override
  List<Object?> get props => [id, code, name, basePrice, prices, unit, unitValue, base, tintingFormulaType];
}
