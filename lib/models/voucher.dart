import 'package:freezed_annotation/freezed_annotation.dart';

part 'voucher.freezed.dart';
part 'voucher.g.dart';

// Helper functions to handle ID conversion from int/String to String
String _stringFromValue(Object? value) => value.toString();
String? _nullableStringFromValue(Object? value) => value?.toString();

@freezed
class Voucher with _$Voucher {
  const factory Voucher({
    @JsonKey(fromJson: _stringFromValue) required String id,
    String? code,
    int? type,
    double? price,
    @JsonKey(fromJson: _nullableStringFromValue) String? branchId,
    DateTime? createdDate,
    DateTime? modifiedDate,
    String? description,
    @JsonKey(fromJson: _nullableStringFromValue) String? customerId,
    String? customerCode,
    String? customerName,
  }) = _Voucher;

  factory Voucher.fromJson(Map<String, dynamic> json) =>
      _$VoucherFromJson(json);
}
