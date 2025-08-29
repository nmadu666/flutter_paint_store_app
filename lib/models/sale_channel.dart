import 'package:freezed_annotation/freezed_annotation.dart';

part 'sale_channel.freezed.dart';
part 'sale_channel.g.dart';

@freezed
class SaleChannel with _$SaleChannel {
  const factory SaleChannel({
    required int id,
    String? name,
    int? retailerId,
    DateTime? modifiedDate,
  }) = _SaleChannel;

  factory SaleChannel.fromJson(Map<String, dynamic> json) =>
      _$SaleChannelFromJson(json);
}
