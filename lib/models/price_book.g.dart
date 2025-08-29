// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'price_book.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PriceBookImpl _$$PriceBookImplFromJson(Map<String, dynamic> json) =>
    _$PriceBookImpl(
      id: (json['id'] as num).toInt(),
      code: json['code'] as String?,
      name: json['name'] as String?,
      retailerId: (json['retailerId'] as num?)?.toInt(),
      modifiedDate: json['modifiedDate'] == null
          ? null
          : DateTime.parse(json['modifiedDate'] as String),
    );

Map<String, dynamic> _$$PriceBookImplToJson(_$PriceBookImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'code': instance.code,
      'name': instance.name,
      'retailerId': instance.retailerId,
      'modifiedDate': instance.modifiedDate?.toIso8601String(),
    };
