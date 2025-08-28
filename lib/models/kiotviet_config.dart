import 'package:freezed_annotation/freezed_annotation.dart';

part 'kiotviet_config.freezed.dart';
part 'kiotviet_config.g.dart';

@freezed
class KiotvietConfig with _$KiotvietConfig {
  const factory KiotvietConfig({
    required String retailer,
    required String clientId,
    required String clientSecret,
  }) = _KiotvietConfig;

  factory KiotvietConfig.fromJson(Map<String, dynamic> json) =>
      _$KiotvietConfigFromJson(json);
}
