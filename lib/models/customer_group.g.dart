// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_group.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CustomerGroupImpl _$$CustomerGroupImplFromJson(Map<String, dynamic> json) =>
    _$CustomerGroupImpl(
      id: _stringFromValue(json['id']),
      groupName: json['groupName'] as String?,
      retailerId: (json['retailerId'] as num?)?.toInt(),
      modifiedDate: json['modifiedDate'] == null
          ? null
          : DateTime.parse(json['modifiedDate'] as String),
    );

Map<String, dynamic> _$$CustomerGroupImplToJson(_$CustomerGroupImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'groupName': instance.groupName,
      'retailerId': instance.retailerId,
      'modifiedDate': instance.modifiedDate?.toIso8601String(),
    };
