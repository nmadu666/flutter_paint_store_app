import 'package:flutter/foundation.dart';

/// Represents a specific price point for a product within a price group.
/// For example, ('Giá bán lẻ', 150000).
@immutable
class ProductPricing {
  final String priceGroup;
  final double price;

  const ProductPricing({required this.priceGroup, required this.price});

  factory ProductPricing.fromJson(Map<String, dynamic> json) {
    return ProductPricing(
      priceGroup: json['priceGroup'] as String,
      price: (json['price'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'priceGroup': priceGroup, 'price': price};
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductPricing &&
          runtimeType == other.runtimeType &&
          priceGroup == other.priceGroup &&
          price == other.price;

  @override
  int get hashCode => priceGroup.hashCode ^ price.hashCode;
}
