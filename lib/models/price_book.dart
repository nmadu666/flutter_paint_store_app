import 'package:freezed_annotation/freezed_annotation.dart';

part 'price_book.freezed.dart';
part 'price_book.g.dart';

@freezed
class PriceBook with _$PriceBook {
  const factory PriceBook({
    required int id,
    String? code,
    String? name,
    int? retailerId,
    DateTime? modifiedDate,
  }) = _PriceBook;

  factory PriceBook.fromJson(Map<String, dynamic> json) =>
      _$PriceBookFromJson(json);
}
