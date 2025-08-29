// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$OrderImpl _$$OrderImplFromJson(Map<String, dynamic> json) => _$OrderImpl(
  id: (json['id'] as num).toInt(),
  code: json['code'] as String?,
  createdDate: json['purchaseDate'] == null
      ? null
      : DateTime.parse(json['purchaseDate'] as String),
  branchId: (json['branchId'] as num?)?.toInt(),
  branchName: json['branchName'] as String?,
  customerId: (json['customerId'] as num?)?.toInt(),
  customerName: json['customerName'] as String?,
  saleChannelId: (json['saleChannelId'] as num?)?.toInt(),
  soldByName: json['soldByName'] as String?,
  description: json['description'] as String?,
  total: (json['total'] as num?)?.toDouble(),
  discount: (json['discount'] as num?)?.toDouble(),
  totalPayment: (json['totalPayment'] as num?)?.toDouble(),
  status: (json['status'] as num?)?.toInt(),
  statusValue: json['statusValue'] as String?,
  orderDetails:
      (json['orderDetails'] as List<dynamic>?)
          ?.map((e) => OrderDetail.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  payments:
      (json['payments'] as List<dynamic>?)
          ?.map((e) => Payment.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  orderDelivery: json['orderDelivery'] == null
      ? null
      : OrderDelivery.fromJson(json['orderDelivery'] as Map<String, dynamic>),
);

Map<String, dynamic> _$$OrderImplToJson(_$OrderImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'code': instance.code,
      'purchaseDate': instance.createdDate?.toIso8601String(),
      'branchId': instance.branchId,
      'branchName': instance.branchName,
      'customerId': instance.customerId,
      'customerName': instance.customerName,
      'saleChannelId': instance.saleChannelId,
      'soldByName': instance.soldByName,
      'description': instance.description,
      'total': instance.total,
      'discount': instance.discount,
      'totalPayment': instance.totalPayment,
      'status': instance.status,
      'statusValue': instance.statusValue,
      'orderDetails': instance.orderDetails,
      'payments': instance.payments,
      'orderDelivery': instance.orderDelivery,
    };

_$OrderDetailImpl _$$OrderDetailImplFromJson(Map<String, dynamic> json) =>
    _$OrderDetailImpl(
      productId: (json['productId'] as num).toInt(),
      productCode: json['productCode'] as String?,
      productName: json['productName'] as String?,
      note: json['note'] as String?,
      quantity: (json['quantity'] as num).toDouble(),
      price: (json['price'] as num?)?.toDouble(),
      discount: (json['discount'] as num?)?.toDouble(),
      priceBookId: (json['priceBookId'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$OrderDetailImplToJson(_$OrderDetailImpl instance) =>
    <String, dynamic>{
      'productId': instance.productId,
      'productCode': instance.productCode,
      'productName': instance.productName,
      'note': instance.note,
      'quantity': instance.quantity,
      'price': instance.price,
      'discount': instance.discount,
      'priceBookId': instance.priceBookId,
    };

_$PaymentImpl _$$PaymentImplFromJson(Map<String, dynamic> json) =>
    _$PaymentImpl(
      method: json['method'] as String?,
      amount: (json['amount'] as num?)?.toDouble(),
      statusValue: json['statusValue'] as String?,
    );

Map<String, dynamic> _$$PaymentImplToJson(_$PaymentImpl instance) =>
    <String, dynamic>{
      'method': instance.method,
      'amount': instance.amount,
      'statusValue': instance.statusValue,
    };

_$OrderDeliveryImpl _$$OrderDeliveryImplFromJson(Map<String, dynamic> json) =>
    _$OrderDeliveryImpl(
      receiver: json['receiver'] as String?,
      contactNumber: json['contactNumber'] as String?,
      address: json['address'] as String?,
      price: (json['price'] as num?)?.toDouble(),
      deliveryCode: json['deliveryCode'] as String?,
    );

Map<String, dynamic> _$$OrderDeliveryImplToJson(_$OrderDeliveryImpl instance) =>
    <String, dynamic>{
      'receiver': instance.receiver,
      'contactNumber': instance.contactNumber,
      'address': instance.address,
      'price': instance.price,
      'deliveryCode': instance.deliveryCode,
    };
