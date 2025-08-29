// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserImpl _$$UserImplFromJson(Map<String, dynamic> json) => _$UserImpl(
  id: (json['id'] as num).toInt(),
  userName: json['userName'] as String?,
  displayName: json['displayName'] as String?,
  retailerId: (json['retailerId'] as num?)?.toInt(),
  modifiedDate: json['modifiedDate'] == null
      ? null
      : DateTime.parse(json['modifiedDate'] as String),
);

Map<String, dynamic> _$$UserImplToJson(_$UserImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userName': instance.userName,
      'displayName': instance.displayName,
      'retailerId': instance.retailerId,
      'modifiedDate': instance.modifiedDate?.toIso8601String(),
    };
