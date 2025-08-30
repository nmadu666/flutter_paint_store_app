// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'branch.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Branch _$BranchFromJson(Map<String, dynamic> json) {
  return _Branch.fromJson(json);
}

/// @nodoc
mixin _$Branch {
  @JsonKey(fromJson: _stringFromValue)
  String get id => throw _privateConstructorUsedError;
  String? get branchName => throw _privateConstructorUsedError;
  String? get contactNumber => throw _privateConstructorUsedError;
  String? get address => throw _privateConstructorUsedError;
  int? get retailerId => throw _privateConstructorUsedError;
  DateTime? get modifiedDate => throw _privateConstructorUsedError;

  /// Serializes this Branch to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Branch
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BranchCopyWith<Branch> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BranchCopyWith<$Res> {
  factory $BranchCopyWith(Branch value, $Res Function(Branch) then) =
      _$BranchCopyWithImpl<$Res, Branch>;
  @useResult
  $Res call({
    @JsonKey(fromJson: _stringFromValue) String id,
    String? branchName,
    String? contactNumber,
    String? address,
    int? retailerId,
    DateTime? modifiedDate,
  });
}

/// @nodoc
class _$BranchCopyWithImpl<$Res, $Val extends Branch>
    implements $BranchCopyWith<$Res> {
  _$BranchCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Branch
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? branchName = freezed,
    Object? contactNumber = freezed,
    Object? address = freezed,
    Object? retailerId = freezed,
    Object? modifiedDate = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            branchName: freezed == branchName
                ? _value.branchName
                : branchName // ignore: cast_nullable_to_non_nullable
                      as String?,
            contactNumber: freezed == contactNumber
                ? _value.contactNumber
                : contactNumber // ignore: cast_nullable_to_non_nullable
                      as String?,
            address: freezed == address
                ? _value.address
                : address // ignore: cast_nullable_to_non_nullable
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
abstract class _$$BranchImplCopyWith<$Res> implements $BranchCopyWith<$Res> {
  factory _$$BranchImplCopyWith(
    _$BranchImpl value,
    $Res Function(_$BranchImpl) then,
  ) = __$$BranchImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(fromJson: _stringFromValue) String id,
    String? branchName,
    String? contactNumber,
    String? address,
    int? retailerId,
    DateTime? modifiedDate,
  });
}

/// @nodoc
class __$$BranchImplCopyWithImpl<$Res>
    extends _$BranchCopyWithImpl<$Res, _$BranchImpl>
    implements _$$BranchImplCopyWith<$Res> {
  __$$BranchImplCopyWithImpl(
    _$BranchImpl _value,
    $Res Function(_$BranchImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Branch
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? branchName = freezed,
    Object? contactNumber = freezed,
    Object? address = freezed,
    Object? retailerId = freezed,
    Object? modifiedDate = freezed,
  }) {
    return _then(
      _$BranchImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        branchName: freezed == branchName
            ? _value.branchName
            : branchName // ignore: cast_nullable_to_non_nullable
                  as String?,
        contactNumber: freezed == contactNumber
            ? _value.contactNumber
            : contactNumber // ignore: cast_nullable_to_non_nullable
                  as String?,
        address: freezed == address
            ? _value.address
            : address // ignore: cast_nullable_to_non_nullable
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
class _$BranchImpl implements _Branch {
  const _$BranchImpl({
    @JsonKey(fromJson: _stringFromValue) required this.id,
    this.branchName,
    this.contactNumber,
    this.address,
    this.retailerId,
    this.modifiedDate,
  });

  factory _$BranchImpl.fromJson(Map<String, dynamic> json) =>
      _$$BranchImplFromJson(json);

  @override
  @JsonKey(fromJson: _stringFromValue)
  final String id;
  @override
  final String? branchName;
  @override
  final String? contactNumber;
  @override
  final String? address;
  @override
  final int? retailerId;
  @override
  final DateTime? modifiedDate;

  @override
  String toString() {
    return 'Branch(id: $id, branchName: $branchName, contactNumber: $contactNumber, address: $address, retailerId: $retailerId, modifiedDate: $modifiedDate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BranchImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.branchName, branchName) ||
                other.branchName == branchName) &&
            (identical(other.contactNumber, contactNumber) ||
                other.contactNumber == contactNumber) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.retailerId, retailerId) ||
                other.retailerId == retailerId) &&
            (identical(other.modifiedDate, modifiedDate) ||
                other.modifiedDate == modifiedDate));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    branchName,
    contactNumber,
    address,
    retailerId,
    modifiedDate,
  );

  /// Create a copy of Branch
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BranchImplCopyWith<_$BranchImpl> get copyWith =>
      __$$BranchImplCopyWithImpl<_$BranchImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BranchImplToJson(this);
  }
}

abstract class _Branch implements Branch {
  const factory _Branch({
    @JsonKey(fromJson: _stringFromValue) required final String id,
    final String? branchName,
    final String? contactNumber,
    final String? address,
    final int? retailerId,
    final DateTime? modifiedDate,
  }) = _$BranchImpl;

  factory _Branch.fromJson(Map<String, dynamic> json) = _$BranchImpl.fromJson;

  @override
  @JsonKey(fromJson: _stringFromValue)
  String get id;
  @override
  String? get branchName;
  @override
  String? get contactNumber;
  @override
  String? get address;
  @override
  int? get retailerId;
  @override
  DateTime? get modifiedDate;

  /// Create a copy of Branch
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BranchImplCopyWith<_$BranchImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
