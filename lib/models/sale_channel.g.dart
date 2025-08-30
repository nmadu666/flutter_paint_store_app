// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sale_channel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SaleChannelImpl _$$SaleChannelImplFromJson(Map<String, dynamic> json) =>
    _$SaleChannelImpl(
      id: _stringFromValue(json['id']),
      name: json['name'] as String?,
      retailerId: (json['retailerId'] as num?)?.toInt(),
      modifiedDate: json['modifiedDate'] == null
          ? null
          : DateTime.parse(json['modifiedDate'] as String),
    );

Map<String, dynamic> _$$SaleChannelImplToJson(_$SaleChannelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'retailerId': instance.retailerId,
      'modifiedDate': instance.modifiedDate?.toIso8601String(),
    };
