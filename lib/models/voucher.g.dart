// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'voucher.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$VoucherImpl _$$VoucherImplFromJson(Map<String, dynamic> json) =>
    _$VoucherImpl(
      id: (json['id'] as num).toInt(),
      code: json['code'] as String?,
      type: (json['type'] as num?)?.toInt(),
      price: (json['price'] as num?)?.toDouble(),
      branchId: (json['branchId'] as num?)?.toInt(),
      createdDate: json['createdDate'] == null
          ? null
          : DateTime.parse(json['createdDate'] as String),
      modifiedDate: json['modifiedDate'] == null
          ? null
          : DateTime.parse(json['modifiedDate'] as String),
      description: json['description'] as String?,
      customerId: (json['customerId'] as num?)?.toInt(),
      customerCode: json['customerCode'] as String?,
      customerName: json['customerName'] as String?,
    );

Map<String, dynamic> _$$VoucherImplToJson(_$VoucherImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'code': instance.code,
      'type': instance.type,
      'price': instance.price,
      'branchId': instance.branchId,
      'createdDate': instance.createdDate?.toIso8601String(),
      'modifiedDate': instance.modifiedDate?.toIso8601String(),
      'description': instance.description,
      'customerId': instance.customerId,
      'customerCode': instance.customerCode,
      'customerName': instance.customerName,
    };
