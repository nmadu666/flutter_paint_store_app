import 'package:freezed_annotation/freezed_annotation.dart';

part 'customer_group.freezed.dart';
part 'customer_group.g.dart';

// Helper function to handle ID conversion from int/String to String
String _stringFromValue(Object? value) => value.toString();

@freezed
class CustomerGroup with _$CustomerGroup {
  const factory CustomerGroup({
    @JsonKey(fromJson: _stringFromValue) required String id,
    String? groupName,
    int? retailerId,
    DateTime? modifiedDate,
  }) = _CustomerGroup;

  factory CustomerGroup.fromJson(Map<String, dynamic> json) =>
      _$CustomerGroupFromJson(json);
}