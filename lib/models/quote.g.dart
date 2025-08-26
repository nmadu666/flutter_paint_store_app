// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quote.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Quote _$QuoteFromJson(Map<String, dynamic> json) => Quote(
  id: json['id'] as String,
  items: (json['items'] as List<dynamic>)
      .map((e) => QuoteItem.fromJson(e as Map<String, dynamic>))
      .toList(),
  customer: json['customer'] == null
      ? null
      : Customer.fromJson(json['customer'] as Map<String, dynamic>),
  createdAt: DateTime.parse(json['createdAt'] as String),
  priceList: json['priceList'] as String?,
  name: json['name'] as String,
);

Map<String, dynamic> _$QuoteToJson(Quote instance) => <String, dynamic>{
  'id': instance.id,
  'items': instance.items.map((e) => e.toJson()).toList(),
  'customer': instance.customer?.toJson(),
  'createdAt': instance.createdAt.toIso8601String(),
  'priceList': instance.priceList,
  'name': instance.name,
};

QuoteItem _$QuoteItemFromJson(Map<String, dynamic> json) => QuoteItem(
  id: json['id'] as String,
  product: Product.fromJson(json['product'] as Map<String, dynamic>),
  color: json['color'] == null
      ? null
      : PaintColor.fromJson(json['color'] as Map<String, dynamic>),
  quantity: (json['quantity'] as num).toInt(),
  unitPrice: (json['unitPrice'] as num).toDouble(),
  tintingCost: (json['tintingCost'] as num?)?.toDouble() ?? 0.0,
  note: json['note'] as String?,
  discount: (json['discount'] as num?)?.toDouble() ?? 0.0,
  discountIsPercentage: json['discountIsPercentage'] as bool? ?? true,
);

Map<String, dynamic> _$QuoteItemToJson(QuoteItem instance) => <String, dynamic>{
  'id': instance.id,
  'product': instance.product.toJson(),
  'color': instance.color?.toJson(),
  'quantity': instance.quantity,
  'unitPrice': instance.unitPrice,
  'tintingCost': instance.tintingCost,
  'note': instance.note,
  'discount': instance.discount,
  'discountIsPercentage': instance.discountIsPercentage,
};
