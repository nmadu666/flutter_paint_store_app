import 'package:freezed_annotation/freezed_annotation.dart';

part 'sale_channel.freezed.dart';
part 'sale_channel.g.dart';

// Helper function to handle ID conversion from int/String to String
String _stringFromValue(Object? value) => value.toString();

@freezed
class SaleChannel with _$SaleChannel {
  const factory SaleChannel({
    @JsonKey(fromJson: _stringFromValue) required String id,
    String? name,
    int? retailerId,
    DateTime? modifiedDate,
  }) = _SaleChannel;

  factory SaleChannel.fromJson(Map<String, dynamic> json) =>
      _$SaleChannelFromJson(json);
}