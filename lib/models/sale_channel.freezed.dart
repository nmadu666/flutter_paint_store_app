// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sale_channel.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

SaleChannel _$SaleChannelFromJson(Map<String, dynamic> json) {
  return _SaleChannel.fromJson(json);
}

/// @nodoc
mixin _$SaleChannel {
  @JsonKey(fromJson: _stringFromValue)
  String get id => throw _privateConstructorUsedError;
  String? get name => throw _privateConstructorUsedError;
  int? get retailerId => throw _privateConstructorUsedError;
  DateTime? get modifiedDate => throw _privateConstructorUsedError;

  /// Serializes this SaleChannel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SaleChannel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SaleChannelCopyWith<SaleChannel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SaleChannelCopyWith<$Res> {
  factory $SaleChannelCopyWith(
    SaleChannel value,
    $Res Function(SaleChannel) then,
  ) = _$SaleChannelCopyWithImpl<$Res, SaleChannel>;
  @useResult
  $Res call({
    @JsonKey(fromJson: _stringFromValue) String id,
    String? name,
    int? retailerId,
    DateTime? modifiedDate,
  });
}

/// @nodoc
class _$SaleChannelCopyWithImpl<$Res, $Val extends SaleChannel>
    implements $SaleChannelCopyWith<$Res> {
  _$SaleChannelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SaleChannel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
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
abstract class _$$SaleChannelImplCopyWith<$Res>
    implements $SaleChannelCopyWith<$Res> {
  factory _$$SaleChannelImplCopyWith(
    _$SaleChannelImpl value,
    $Res Function(_$SaleChannelImpl) then,
  ) = __$$SaleChannelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(fromJson: _stringFromValue) String id,
    String? name,
    int? retailerId,
    DateTime? modifiedDate,
  });
}

/// @nodoc
class __$$SaleChannelImplCopyWithImpl<$Res>
    extends _$SaleChannelCopyWithImpl<$Res, _$SaleChannelImpl>
    implements _$$SaleChannelImplCopyWith<$Res> {
  __$$SaleChannelImplCopyWithImpl(
    _$SaleChannelImpl _value,
    $Res Function(_$SaleChannelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SaleChannel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = freezed,
    Object? retailerId = freezed,
    Object? modifiedDate = freezed,
  }) {
    return _then(
      _$SaleChannelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
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
class _$SaleChannelImpl implements _SaleChannel {
  const _$SaleChannelImpl({
    @JsonKey(fromJson: _stringFromValue) required this.id,
    this.name,
    this.retailerId,
    this.modifiedDate,
  });

  factory _$SaleChannelImpl.fromJson(Map<String, dynamic> json) =>
      _$$SaleChannelImplFromJson(json);

  @override
  @JsonKey(fromJson: _stringFromValue)
  final String id;
  @override
  final String? name;
  @override
  final int? retailerId;
  @override
  final DateTime? modifiedDate;

  @override
  String toString() {
    return 'SaleChannel(id: $id, name: $name, retailerId: $retailerId, modifiedDate: $modifiedDate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SaleChannelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.retailerId, retailerId) ||
                other.retailerId == retailerId) &&
            (identical(other.modifiedDate, modifiedDate) ||
                other.modifiedDate == modifiedDate));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, name, retailerId, modifiedDate);

  /// Create a copy of SaleChannel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SaleChannelImplCopyWith<_$SaleChannelImpl> get copyWith =>
      __$$SaleChannelImplCopyWithImpl<_$SaleChannelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SaleChannelImplToJson(this);
  }
}

abstract class _SaleChannel implements SaleChannel {
  const factory _SaleChannel({
    @JsonKey(fromJson: _stringFromValue) required final String id,
    final String? name,
    final int? retailerId,
    final DateTime? modifiedDate,
  }) = _$SaleChannelImpl;

  factory _SaleChannel.fromJson(Map<String, dynamic> json) =
      _$SaleChannelImpl.fromJson;

  @override
  @JsonKey(fromJson: _stringFromValue)
  String get id;
  @override
  String? get name;
  @override
  int? get retailerId;
  @override
  DateTime? get modifiedDate;

  /// Create a copy of SaleChannel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SaleChannelImplCopyWith<_$SaleChannelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
