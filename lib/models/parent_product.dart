import 'package:flutter/foundation.dart';
import 'package:flutter_paint_store_app/models/product.dart';

@immutable
class ParentProduct {
  final String id;
  final String name;
  final String brand;
  final String category;
  final String imageUrl;
  final String? tintingFormulaType;
  final List<Product> children;

  const ParentProduct({
    required this.id,
    required this.name,
    required this.brand,
    required this.category,
    required this.imageUrl,
    this.tintingFormulaType,
    required this.children,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ParentProduct &&
        other.id == id &&
        other.name == name &&
        other.brand == brand &&
        other.category == category &&
        other.imageUrl == imageUrl &&
        other.tintingFormulaType == tintingFormulaType &&
        listEquals(other.children, children);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        brand.hashCode ^
        category.hashCode ^
        imageUrl.hashCode ^
        tintingFormulaType.hashCode ^
        children.hashCode;
  }

  @override
  String toString() {
    return 'ParentProduct(id: $id, name: $name, brand: $brand, category: $category, imageUrl: $imageUrl, tintingFormulaType: $tintingFormulaType, children: $children)';
  }

  ParentProduct copyWith({
    String? id,
    String? name,
    String? brand,
    String? category,
    String? imageUrl,
    String? tintingFormulaType,
    List<Product>? children,
  }) {
    return ParentProduct(
      id: id ?? this.id,
      name: name ?? this.name,
      brand: brand ?? this.brand,
      category: category ?? this.category,
      imageUrl: imageUrl ?? this.imageUrl,
      tintingFormulaType: tintingFormulaType ?? this.tintingFormulaType,
      children: children ?? this.children,
    );
  }
}
