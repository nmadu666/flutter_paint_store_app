import 'package:flutter/foundation.dart';

/// Represents a paint product available in the store.
class Product {
  final String id;
  final String name;
  final String code;
  final List<ProductPricing> pricing;

  const Product({
    required this.id,
    required this.name,
    required this.code,
    required this.pricing,
  });

  Product copyWith({
    String? id,
    String? name,
    String? code,
    List<ProductPricing>? pricing,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      code: code ?? this.code,
      pricing: pricing ?? this.pricing,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Product &&
        other.id == id &&
        other.name == name &&
        other.code == code &&
        listEquals(other.pricing, pricing);
  }

  @override
  int get hashCode =>
      id.hashCode ^ name.hashCode ^ code.hashCode ^ pricing.hashCode;
}

/// Defines the cost of a product for a specific price group.
class ProductPricing {
  final String priceGroup;
  final double cost;

  const ProductPricing({required this.priceGroup, required this.cost});

  ProductPricing copyWith({String? priceGroup, double? cost}) {
    return ProductPricing(
      priceGroup: priceGroup ?? this.priceGroup,
      cost: cost ?? this.cost,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ProductPricing &&
        other.priceGroup == priceGroup &&
        other.cost == cost;
  }

  @override
  int get hashCode => priceGroup.hashCode ^ cost.hashCode;
}
