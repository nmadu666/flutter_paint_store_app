import 'package:flutter/foundation.dart';
import 'package:flutter_paint_store_app/models/product.dart';

@immutable
class CostItem {
  const CostItem({
    required this.product,
    this.quantity = 1,
    required this.basePrice,
    double? unitPrice,
    required this.tintCost,
    this.discount = 0,
    this.isDiscountInPercent = false,
  }) : unitPrice = unitPrice ?? basePrice;

  final Product product;
  final int quantity;
  final double basePrice;
  final double unitPrice;
  final double tintCost;
  final double discount;
  final bool isDiscountInPercent;

  double get discountAmount {
    if (isDiscountInPercent) {
      return (unitPrice * quantity) * (discount / 100);
    }
    return discount;
  }

  double get totalBasePrice => unitPrice * quantity;

  double get totalTintCost => tintCost * quantity;

  double get finalPrice => totalBasePrice + totalTintCost - discountAmount;

  CostItem copyWith({
    Product? product,
    int? quantity,
    double? basePrice,
    double? unitPrice,
    double? tintCost,
    double? discount,
    bool? isDiscountInPercent,
  }) {
    return CostItem(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
      basePrice: basePrice ?? this.basePrice,
      unitPrice: unitPrice ?? this.unitPrice,
      tintCost: tintCost ?? this.tintCost,
      discount: discount ?? this.discount,
      isDiscountInPercent: isDiscountInPercent ?? this.isDiscountInPercent,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CostItem &&
          runtimeType == other.runtimeType &&
          product.id == other.product.id;

  @override
  int get hashCode => product.id.hashCode;
}

