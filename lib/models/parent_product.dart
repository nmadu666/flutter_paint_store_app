import 'package:flutter/foundation.dart';
import 'package:flutter_paint_store_app/models/product.dart';

/// Represents a main product line that contains various child products (bases).
/// For example, "Jotun Majestic" is a ParentProduct, and its children are
/// "Jotun Majestic - Base A", "Jotun Majestic - Base D", etc.
@immutable
class ParentProduct {
  final String id;
  final String name;
  final String brand;
  final String category;
  /// The type of tinting formula shared by all children, if applicable.
  /// e.g., 'int_1', 'ext_1'. Null for non-tintable product lines.
  final String? tintingFormulaType;
  final List<Product> children;

  const ParentProduct({
    required this.id,
    required this.name,
    required this.brand,
    required this.category,
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
        other.tintingFormulaType == tintingFormulaType &&
        listEquals(other.children, children);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        brand.hashCode ^
        category.hashCode ^
        tintingFormulaType.hashCode ^
        children.hashCode;
  }

  @override
  String toString() {
    return 'ParentProduct(id: $id, name: $name, brand: $brand, category: $category, tintingFormulaType: $tintingFormulaType, children: $children)';
  }

  ParentProduct copyWith({
    String? id,
    String? name,
    String? brand,
    String? category,
    String? tintingFormulaType,
    List<Product>? children,
  }) {
    return ParentProduct(
      id: id ?? this.id,
      name: name ?? this.name,
      brand: brand ?? this.brand,
      category: category ?? this.category,
      tintingFormulaType: tintingFormulaType ?? this.tintingFormulaType,
      children: children ?? this.children,
    );
  }
}
