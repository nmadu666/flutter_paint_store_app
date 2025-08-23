import 'package:flutter/foundation.dart';
import 'package:flutter_paint_store_app/models/customer.dart';
import 'package:flutter_paint_store_app/models/paint_color.dart';
import 'package:flutter_paint_store_app/models/product.dart';

@immutable
class Quote {
  final String id;
  final List<QuoteItem> items;
  final Customer? customer;
  final DateTime createdAt;

  const Quote({
    required this.id,
    required this.items,
    this.customer,
    required this.createdAt,
  });

  Quote copyWith({
    String? id,
    List<QuoteItem>? items,
    Customer? customer,
    DateTime? createdAt,
  }) {
    return Quote(
      id: id ?? this.id,
      items: items ?? this.items,
      customer: customer ?? this.customer,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

@immutable
class QuoteItem {
  final String id;
  final Product product;
  final PaintColor? color;
  final int quantity;
  final double unitPrice;
  final double tintingCost;
  final String? note;
  final double discountValue;
  final bool isDiscountPercentage;

  const QuoteItem({
    required this.id,
    required this.product,
    this.color,
    required this.quantity,
    required this.unitPrice,
    this.tintingCost = 0.0,
    this.note,
    this.discountValue = 0.0,
    this.isDiscountPercentage = false,
  });

  double get totalDiscount {
    if (isDiscountPercentage) {
      return (unitPrice * quantity) * (discountValue / 100);
    }
    return discountValue * quantity;
  }

  double get totalPrice {
    final basePriceTotal = unitPrice * quantity;
    final totalTintingCost = tintingCost * quantity;
    return (basePriceTotal - totalDiscount) + totalTintingCost;
  }

  QuoteItem copyWith({
    String? id,
    Product? product,
    PaintColor? color,
    int? quantity,
    double? unitPrice,
    double? tintingCost,
    String? note,
    double? discountValue,
    bool? isDiscountPercentage,
  }) {
    return QuoteItem(
      id: id ?? this.id,
      product: product ?? this.product,
      color: color ?? this.color,
      quantity: quantity ?? this.quantity,
      unitPrice: unitPrice ?? this.unitPrice,
      tintingCost: tintingCost ?? this.tintingCost,
      note: note ?? this.note,
      discountValue: discountValue ?? this.discountValue,
      isDiscountPercentage: isDiscountPercentage ?? this.isDiscountPercentage,
    );
  }
}