import 'package:flutter_paint_store_app/models/customer.dart';
import 'package:flutter_paint_store_app/models/paint_color.dart';
import 'package:flutter_paint_store_app/models/product.dart';
import 'package:json_annotation/json_annotation.dart';

part 'quote.g.dart';

@JsonSerializable(explicitToJson: true)
class Quote {
  final String id;
  final List<QuoteItem> items;
  final Customer? customer;
  final DateTime createdAt;
  final String? priceList;
  String name;

  Quote({
    required this.id,
    required this.items,
    this.customer,
    required this.createdAt,
    this.priceList,
    required this.name,
  });

  factory Quote.initial(int tabIndex) {
    return Quote(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      items: [],
      createdAt: DateTime.now(),
      customer: null,
      priceList: null,
      name: 'Báo giá ${tabIndex + 1}',
    );
  }

  Quote copyWith({
    String? id,
    List<QuoteItem>? items,
    Customer? customer,
    DateTime? createdAt,
    String? priceList,
    String? name,
  }) {
    return Quote(
      id: id ?? this.id,
      items: items ?? this.items,
      customer: customer ?? this.customer,
      createdAt: createdAt ?? this.createdAt,
      priceList: priceList ?? this.priceList,
      name: name ?? this.name,
    );
  }

  factory Quote.fromJson(Map<String, dynamic> json) => _$QuoteFromJson(json);
  Map<String, dynamic> toJson() => _$QuoteToJson(this);
}

@JsonSerializable(explicitToJson: true)
class QuoteItem {
  final String id;
  final Product product;
  final PaintColor? color;
  final int quantity;
  final double unitPrice;
  final double tintingCost;
  final String? note;

  /// The value of the discount. Can be a percentage (e.g., 10.0 for 10%)
  /// or a fixed currency amount per item.
  final double discount;

  /// If true, `discount` is treated as a percentage.
  /// If false, it's a fixed currency amount per item.
  final bool discountIsPercentage;

  QuoteItem({
    required this.id,
    required this.product,
    this.color,
    required this.quantity,
    required this.unitPrice,
    this.tintingCost = 0.0,
    this.note,
    this.discount = 0.0,
    this.discountIsPercentage = true, // Default to percentage, which is common
  });

  /// The subtotal before any discounts or costs. (unitPrice * quantity)
  double get subtotal => unitPrice * quantity;

  /// The discount value if it's a percentage, otherwise 0.0.
  double get discountAsPercentage => discountIsPercentage ? discount : 0.0;

  /// The discount value if it's a fixed amount per item, otherwise 0.0.
  double get discountAsFixedAmount => !discountIsPercentage ? discount : 0.0;

  /// The calculated total discount amount in currency.
  double get totalDiscountAmount {
    if (discountIsPercentage) {
      return subtotal * (discount / 100);
    }
    // Fixed amount per item
    return discount * quantity;
  }

  /// The final total price for this item line.
  double get totalPrice {
    final totalTintingCost = tintingCost * quantity;
    return (subtotal - totalDiscountAmount) + totalTintingCost;
  }

  QuoteItem copyWith({
    String? id,
    Product? product,
    PaintColor? color,
    int? quantity,
    double? unitPrice,
    double? tintingCost,
    String? note,
    double? discount,
    bool? discountIsPercentage,
  }) {
    return QuoteItem(
      id: id ?? this.id,
      product: product ?? this.product,
      color: color ?? this.color,
      quantity: quantity ?? this.quantity,
      unitPrice: unitPrice ?? this.unitPrice,
      tintingCost: tintingCost ?? this.tintingCost,
      note: note ?? this.note,
      discount: discount ?? this.discount,
      discountIsPercentage: discountIsPercentage ?? this.discountIsPercentage,
    );
  }

  factory QuoteItem.fromJson(Map<String, dynamic> json) =>
      _$QuoteItemFromJson(json);
  Map<String, dynamic> toJson() => _$QuoteItemToJson(this);
}
