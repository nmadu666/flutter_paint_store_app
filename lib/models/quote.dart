import 'package:flutter/foundation.dart';
import 'package:flutter_paint_store_app/models/customer.dart';
import 'package:flutter_paint_store_app/models/paint_color.dart';
import 'package:flutter_paint_store_app/models/product.dart';

@immutable
class Quote {
  final String id;
  final Customer? customer;
  final List<QuoteItem> items;
  final DateTime createdAt;

  const Quote({
    required this.id,
    this.customer,
    required this.items,
    required this.createdAt,
  });

  double get totalPrice =>
      items.fold(0.0, (sum, item) => sum + item.totalPrice);

  Quote copyWith({
    String? id,
    Customer? customer,
    List<QuoteItem>? items,
    DateTime? createdAt,
  }) {
    return Quote(
      id: id ?? this.id,
      customer: customer ?? this.customer,
      items: items ?? this.items,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

@immutable
class QuoteItem {
  /// A unique identifier for this specific quote item instance.
  final String id;
  final Product product;
  /// The color, if this is a tinted product. Null for non-tinted products.
  final PaintColor? color;
  final int quantity;
  /// The price per unit at the time it was added to the quote.
  final double unitPrice;

  const QuoteItem({
    required this.id,
    required this.product,
    this.color,
    required this.quantity,
    required this.unitPrice,
  });

  /// The total price for this line item.
  double get totalPrice => unitPrice * quantity;

  QuoteItem copyWith(
          {String? id,
          Product? product,
          PaintColor? color,
          int? quantity,
          double? unitPrice}) =>
      QuoteItem(
        id: id ?? this.id,
        product: product ?? this.product,
        color: color ?? this.color,
        quantity: quantity ?? this.quantity,
        unitPrice: unitPrice ?? this.unitPrice,
      );
}
