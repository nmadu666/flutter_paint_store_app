import 'package:freezed_annotation/freezed_annotation.dart';

part 'voucher.freezed.dart';
part 'voucher.g.dart';

@freezed
class Voucher with _$Voucher {
  const factory Voucher({
    required int id,
    String? code,
    int? type,
    double? price,
    int? branchId,
    DateTime? createdDate,
    DateTime? modifiedDate,
    String? description,
    int? customerId,
    String? customerCode,
    String? customerName,
  }) = _Voucher;

  factory Voucher.fromJson(Map<String, dynamic> json) =>
      _$VoucherFromJson(json);
}
