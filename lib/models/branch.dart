import 'package:freezed_annotation/freezed_annotation.dart';

part 'branch.freezed.dart';
part 'branch.g.dart';

// Helper function to handle ID conversion from int/String to String
String _stringFromValue(Object? value) => value.toString();

@freezed
class Branch with _$Branch {
  const factory Branch({
    @JsonKey(fromJson: _stringFromValue) required String id,
    String? branchName,
    String? contactNumber,
    String? address,
    int? retailerId,
    DateTime? modifiedDate,
  }) = _Branch;

  factory Branch.fromJson(Map<String, dynamic> json) => _$BranchFromJson(json);
}