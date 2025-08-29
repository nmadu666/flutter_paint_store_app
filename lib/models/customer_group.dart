import 'package:freezed_annotation/freezed_annotation.dart';

part 'customer_group.freezed.dart';
part 'customer_group.g.dart';

@freezed
class CustomerGroup with _$CustomerGroup {
  const factory CustomerGroup({
    required int id,
    String? groupName,
    int? retailerId,
    DateTime? modifiedDate,
  }) = _CustomerGroup;

  factory CustomerGroup.fromJson(Map<String, dynamic> json) =>
      _$CustomerGroupFromJson(json);
}
