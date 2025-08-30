import 'package:freezed_annotation/freezed_annotation.dart';

part 'price_book.freezed.dart';
part 'price_book.g.dart';

// Helper function to handle ID conversion from int/String to String
String _stringFromValue(Object? value) => value.toString();

@freezed
class PriceBook with _$PriceBook {
  const factory PriceBook({
    @JsonKey(fromJson: _stringFromValue) required String id,
    String? code,
    String? name,
    int? retailerId,
    DateTime? modifiedDate,
  }) = _PriceBook;

  factory PriceBook.fromJson(Map<String, dynamic> json) =>
      _$PriceBookFromJson(json);
}