class Quote {
  final String id;
  final String customerId;
  final List<QuoteItem> items;
  final DateTime createdAt;
  final String createdBy;
  final double totalPrice;
  Quote({
    required this.id,
    required this.customerId,
    required this.items,
    required this.createdAt,
    required this.createdBy,
    required this.totalPrice,
  });
}

class QuoteItem {
  final String productId;
  final String productName;
  final String colorName;
  final String hexCode;
  final String base;
  final double quantity;
  final double unitPrice;
  final double totalPrice;
  final String sku;
  QuoteItem({
    required this.productId,
    required this.productName,
    required this.colorName,
    required this.hexCode,
    required this.base,
    required this.quantity,
    required this.unitPrice,
    required this.totalPrice,
    required this.sku,
  });

  QuoteItem copyWith({
    String? productId,
    String? productName,
    String? colorName,
    String? hexCode,
    String? base,
    double? quantity,
    double? unitPrice,
    double? totalPrice,
    String? sku,
  }) {
    return QuoteItem(
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      colorName: colorName ?? this.colorName,
      hexCode: hexCode ?? this.hexCode,
      base: base ?? this.base,
      quantity: quantity ?? this.quantity,
      unitPrice: unitPrice ?? this.unitPrice,
      totalPrice: totalPrice ?? this.totalPrice,
      sku: sku ?? this.sku,
    );
  }
}
