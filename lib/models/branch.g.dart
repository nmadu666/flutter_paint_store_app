// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'branch.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BranchImpl _$$BranchImplFromJson(Map<String, dynamic> json) => _$BranchImpl(
  id: (json['id'] as num).toInt(),
  branchName: json['branchName'] as String?,
  contactNumber: json['contactNumber'] as String?,
  address: json['address'] as String?,
  retailerId: (json['retailerId'] as num?)?.toInt(),
  modifiedDate: json['modifiedDate'] == null
      ? null
      : DateTime.parse(json['modifiedDate'] as String),
);

Map<String, dynamic> _$$BranchImplToJson(_$BranchImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'branchName': instance.branchName,
      'contactNumber': instance.contactNumber,
      'address': instance.address,
      'retailerId': instance.retailerId,
      'modifiedDate': instance.modifiedDate?.toIso8601String(),
    };
