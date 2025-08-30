import 'package:freezed_annotation/freezed_annotation.dart';

part 'category.freezed.dart';
part 'category.g.dart';

// Helper functions to handle ID conversion from int/String to String
String _stringFromValue(Object? value) => value.toString();
String? _nullableStringFromValue(Object? value) => value?.toString();

@freezed
class Category with _$Category {
  const factory Category({
    @JsonKey(name: 'categoryId', fromJson: _stringFromValue) required String id,
    String? categoryName,
    @JsonKey(fromJson: _nullableStringFromValue) String? parentId,
    bool? hasChild,
    DateTime? modifiedDate,
    int? retailerId,
  }) = _Category;

  factory Category.fromJson(Map<String, dynamic> json) =>
      _$CategoryFromJson(json);
}
