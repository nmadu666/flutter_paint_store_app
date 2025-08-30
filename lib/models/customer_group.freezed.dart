// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'customer_group.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

CustomerGroup _$CustomerGroupFromJson(Map<String, dynamic> json) {
  return _CustomerGroup.fromJson(json);
}

/// @nodoc
mixin _$CustomerGroup {
  @JsonKey(fromJson: _stringFromValue)
  String get id => throw _privateConstructorUsedError;
  String? get groupName => throw _privateConstructorUsedError;
  int? get retailerId => throw _privateConstructorUsedError;
  DateTime? get modifiedDate => throw _privateConstructorUsedError;

  /// Serializes this CustomerGroup to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CustomerGroup
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CustomerGroupCopyWith<CustomerGroup> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CustomerGroupCopyWith<$Res> {
  factory $CustomerGroupCopyWith(
    CustomerGroup value,
    $Res Function(CustomerGroup) then,
  ) = _$CustomerGroupCopyWithImpl<$Res, CustomerGroup>;
  @useResult
  $Res call({
    @JsonKey(fromJson: _stringFromValue) String id,
    String? groupName,
    int? retailerId,
    DateTime? modifiedDate,
  });
}

/// @nodoc
class _$CustomerGroupCopyWithImpl<$Res, $Val extends CustomerGroup>
    implements $CustomerGroupCopyWith<$Res> {
  _$CustomerGroupCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CustomerGroup
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? groupName = freezed,
    Object? retailerId = freezed,
    Object? modifiedDate = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            groupName: freezed == groupName
                ? _value.groupName
                : groupName // ignore: cast_nullable_to_non_nullable
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
abstract class _$$CustomerGroupImplCopyWith<$Res>
    implements $CustomerGroupCopyWith<$Res> {
  factory _$$CustomerGroupImplCopyWith(
    _$CustomerGroupImpl value,
    $Res Function(_$CustomerGroupImpl) then,
  ) = __$$CustomerGroupImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(fromJson: _stringFromValue) String id,
    String? groupName,
    int? retailerId,
    DateTime? modifiedDate,
  });
}

/// @nodoc
class __$$CustomerGroupImplCopyWithImpl<$Res>
    extends _$CustomerGroupCopyWithImpl<$Res, _$CustomerGroupImpl>
    implements _$$CustomerGroupImplCopyWith<$Res> {
  __$$CustomerGroupImplCopyWithImpl(
    _$CustomerGroupImpl _value,
    $Res Function(_$CustomerGroupImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CustomerGroup
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? groupName = freezed,
    Object? retailerId = freezed,
    Object? modifiedDate = freezed,
  }) {
    return _then(
      _$CustomerGroupImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        groupName: freezed == groupName
            ? _value.groupName
            : groupName // ignore: cast_nullable_to_non_nullable
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
class _$CustomerGroupImpl implements _CustomerGroup {
  const _$CustomerGroupImpl({
    @JsonKey(fromJson: _stringFromValue) required this.id,
    this.groupName,
    this.retailerId,
    this.modifiedDate,
  });

  factory _$CustomerGroupImpl.fromJson(Map<String, dynamic> json) =>
      _$$CustomerGroupImplFromJson(json);

  @override
  @JsonKey(fromJson: _stringFromValue)
  final String id;
  @override
  final String? groupName;
  @override
  final int? retailerId;
  @override
  final DateTime? modifiedDate;

  @override
  String toString() {
    return 'CustomerGroup(id: $id, groupName: $groupName, retailerId: $retailerId, modifiedDate: $modifiedDate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CustomerGroupImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.groupName, groupName) ||
                other.groupName == groupName) &&
            (identical(other.retailerId, retailerId) ||
                other.retailerId == retailerId) &&
            (identical(other.modifiedDate, modifiedDate) ||
                other.modifiedDate == modifiedDate));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, groupName, retailerId, modifiedDate);

  /// Create a copy of CustomerGroup
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CustomerGroupImplCopyWith<_$CustomerGroupImpl> get copyWith =>
      __$$CustomerGroupImplCopyWithImpl<_$CustomerGroupImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CustomerGroupImplToJson(this);
  }
}

abstract class _CustomerGroup implements CustomerGroup {
  const factory _CustomerGroup({
    @JsonKey(fromJson: _stringFromValue) required final String id,
    final String? groupName,
    final int? retailerId,
    final DateTime? modifiedDate,
  }) = _$CustomerGroupImpl;

  factory _CustomerGroup.fromJson(Map<String, dynamic> json) =
      _$CustomerGroupImpl.fromJson;

  @override
  @JsonKey(fromJson: _stringFromValue)
  String get id;
  @override
  String? get groupName;
  @override
  int? get retailerId;
  @override
  DateTime? get modifiedDate;

  /// Create a copy of CustomerGroup
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CustomerGroupImplCopyWith<_$CustomerGroupImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
