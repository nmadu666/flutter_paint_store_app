// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'price_book.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

PriceBook _$PriceBookFromJson(Map<String, dynamic> json) {
  return _PriceBook.fromJson(json);
}

/// @nodoc
mixin _$PriceBook {
  @JsonKey(fromJson: _stringFromValue)
  String get id => throw _privateConstructorUsedError;
  String? get code => throw _privateConstructorUsedError;
  String? get name => throw _privateConstructorUsedError;
  int? get retailerId => throw _privateConstructorUsedError;
  DateTime? get modifiedDate => throw _privateConstructorUsedError;

  /// Serializes this PriceBook to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PriceBook
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PriceBookCopyWith<PriceBook> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PriceBookCopyWith<$Res> {
  factory $PriceBookCopyWith(PriceBook value, $Res Function(PriceBook) then) =
      _$PriceBookCopyWithImpl<$Res, PriceBook>;
  @useResult
  $Res call({
    @JsonKey(fromJson: _stringFromValue) String id,
    String? code,
    String? name,
    int? retailerId,
    DateTime? modifiedDate,
  });
}

/// @nodoc
class _$PriceBookCopyWithImpl<$Res, $Val extends PriceBook>
    implements $PriceBookCopyWith<$Res> {
  _$PriceBookCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PriceBook
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? code = freezed,
    Object? name = freezed,
    Object? retailerId = freezed,
    Object? modifiedDate = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            code: freezed == code
                ? _value.code
                : code // ignore: cast_nullable_to_non_nullable
                      as String?,
            name: freezed == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String?,
            retailerId: freezed == retailerId
                ? _value.retailerId
                : retailerId // ignore: cast_nullable_to_non_nullable
                      as int?,
            modifiedDate: freezed == modifiedDate
                ? _value.modifiedDate
                : modifiedDate // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PriceBookImplCopyWith<$Res>
    implements $PriceBookCopyWith<$Res> {
  factory _$$PriceBookImplCopyWith(
    _$PriceBookImpl value,
    $Res Function(_$PriceBookImpl) then,
  ) = __$$PriceBookImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(fromJson: _stringFromValue) String id,
    String? code,
    String? name,
    int? retailerId,
    DateTime? modifiedDate,
  });
}

/// @nodoc
class __$$PriceBookImplCopyWithImpl<$Res>
    extends _$PriceBookCopyWithImpl<$Res, _$PriceBookImpl>
    implements _$$PriceBookImplCopyWith<$Res> {
  __$$PriceBookImplCopyWithImpl(
    _$PriceBookImpl _value,
    $Res Function(_$PriceBookImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PriceBook
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? code = freezed,
    Object? name = freezed,
    Object? retailerId = freezed,
    Object? modifiedDate = freezed,
  }) {
    return _then(
      _$PriceBookImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        code: freezed == code
            ? _value.code
            : code // ignore: cast_nullable_to_non_nullable
                  as String?,
        name: freezed == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String?,
        retailerId: freezed == retailerId
            ? _value.retailerId
            : retailerId // ignore: cast_nullable_to_non_nullable
                  as int?,
        modifiedDate: freezed == modifiedDate
            ? _value.modifiedDate
            : modifiedDate // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PriceBookImpl implements _PriceBook {
  const _$PriceBookImpl({
    @JsonKey(fromJson: _stringFromValue) required this.id,
    this.code,
    this.name,
    this.retailerId,
    this.modifiedDate,
  });

  factory _$PriceBookImpl.fromJson(Map<String, dynamic> json) =>
      _$$PriceBookImplFromJson(json);

  @override
  @JsonKey(fromJson: _stringFromValue)
  final String id;
  @override
  final String? code;
  @override
  final String? name;
  @override
  final int? retailerId;
  @override
  final DateTime? modifiedDate;

  @override
  String toString() {
    return 'PriceBook(id: $id, code: $code, name: $name, retailerId: $retailerId, modifiedDate: $modifiedDate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PriceBookImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.retailerId, retailerId) ||
                other.retailerId == retailerId) &&
            (identical(other.modifiedDate, modifiedDate) ||
                other.modifiedDate == modifiedDate));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, code, name, retailerId, modifiedDate);

  /// Create a copy of PriceBook
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PriceBookImplCopyWith<_$PriceBookImpl> get copyWith =>
      __$$PriceBookImplCopyWithImpl<_$PriceBookImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PriceBookImplToJson(this);
  }
}

abstract class _PriceBook implements PriceBook {
  const factory _PriceBook({
    @JsonKey(fromJson: _stringFromValue) required final String id,
    final String? code,
    final String? name,
    final int? retailerId,
    final DateTime? modifiedDate,
  }) = _$PriceBookImpl;

  factory _PriceBook.fromJson(Map<String, dynamic> json) =
      _$PriceBookImpl.fromJson;

  @override
  @JsonKey(fromJson: _stringFromValue)
  String get id;
  @override
  String? get code;
  @override
  String? get name;
  @override
  int? get retailerId;
  @override
  DateTime? get modifiedDate;

  /// Create a copy of PriceBook
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PriceBookImplCopyWith<_$PriceBookImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
