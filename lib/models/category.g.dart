// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CategoryImpl _$$CategoryImplFromJson(Map<String, dynamic> json) =>
    _$CategoryImpl(
      categoryId: (json['categoryId'] as num).toInt(),
      categoryName: json['categoryName'] as String?,
      parentId: (json['parentId'] as num?)?.toInt(),
      hasChild: json['hasChild'] as bool?,
      modifiedDate: json['modifiedDate'] == null
          ? null
          : DateTime.parse(json['modifiedDate'] as String),
      retailerId: (json['retailerId'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$CategoryImplToJson(_$CategoryImpl instance) =>
    <String, dynamic>{
      'categoryId': instance.categoryId,
      'categoryName': instance.categoryName,
      'parentId': instance.parentId,
      'hasChild': instance.hasChild,
      'modifiedDate': instance.modifiedDate?.toIso8601String(),
      'retailerId': instance.retailerId,
    };
