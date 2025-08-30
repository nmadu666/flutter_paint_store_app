// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'voucher.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Voucher _$VoucherFromJson(Map<String, dynamic> json) {
  return _Voucher.fromJson(json);
}

/// @nodoc
mixin _$Voucher {
  @JsonKey(fromJson: _stringFromValue)
  String get id => throw _privateConstructorUsedError;
  String? get code => throw _privateConstructorUsedError;
  int? get type => throw _privateConstructorUsedError;
  double? get price => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _nullableStringFromValue)
  String? get branchId => throw _privateConstructorUsedError;
  DateTime? get createdDate => throw _privateConstructorUsedError;
  DateTime? get modifiedDate => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _nullableStringFromValue)
  String? get customerId => throw _privateConstructorUsedError;
  String? get customerCode => throw _privateConstructorUsedError;
  String? get customerName => throw _privateConstructorUsedError;

  /// Serializes this Voucher to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Voucher
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $VoucherCopyWith<Voucher> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VoucherCopyWith<$Res> {
  factory $VoucherCopyWith(Voucher value, $Res Function(Voucher) then) =
      _$VoucherCopyWithImpl<$Res, Voucher>;
  @useResult
  $Res call({
    @JsonKey(fromJson: _stringFromValue) String id,
    String? code,
    int? type,
    double? price,
    @JsonKey(fromJson: _nullableStringFromValue) String? branchId,
    DateTime? createdDate,
    DateTime? modifiedDate,
    String? description,
    @JsonKey(fromJson: _nullableStringFromValue) String? customerId,
    String? customerCode,
    String? customerName,
  });
}

/// @nodoc
class _$VoucherCopyWithImpl<$Res, $Val extends Voucher>
    implements $VoucherCopyWith<$Res> {
  _$VoucherCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Voucher
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? code = freezed,
    Object? type = freezed,
    Object? price = freezed,
    Object? branchId = freezed,
    Object? createdDate = freezed,
    Object? modifiedDate = freezed,
    Object? description = freezed,
    Object? customerId = freezed,
    Object? customerCode = freezed,
    Object? customerName = freezed,
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
            type: freezed == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as int?,
            price: freezed == price
                ? _value.price
                : price // ignore: cast_nullable_to_non_nullable
                      as double?,
            branchId: freezed == branchId
                ? _value.branchId
                : branchId // ignore: cast_nullable_to_non_nullable
                      as String?,
            createdDate: freezed == createdDate
                ? _value.createdDate
                : createdDate // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            modifiedDate: freezed == modifiedDate
                ? _value.modifiedDate
                : modifiedDate // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
            customerId: freezed == customerId
                ? _value.customerId
                : customerId // ignore: cast_nullable_to_non_nullable
                      as String?,
            customerCode: freezed == customerCode
                ? _value.customerCode
                : customerCode // ignore: cast_nullable_to_non_nullable
                      as String?,
            customerName: freezed == customerName
                ? _value.customerName
                : customerName // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$VoucherImplCopyWith<$Res> implements $VoucherCopyWith<$Res> {
  factory _$$VoucherImplCopyWith(
    _$VoucherImpl value,
    $Res Function(_$VoucherImpl) then,
  ) = __$$VoucherImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(fromJson: _stringFromValue) String id,
    String? code,
    int? type,
    double? price,
    @JsonKey(fromJson: _nullableStringFromValue) String? branchId,
    DateTime? createdDate,
    DateTime? modifiedDate,
    String? description,
    @JsonKey(fromJson: _nullableStringFromValue) String? customerId,
    String? customerCode,
    String? customerName,
  });
}

/// @nodoc
class __$$VoucherImplCopyWithImpl<$Res>
    extends _$VoucherCopyWithImpl<$Res, _$VoucherImpl>
    implements _$$VoucherImplCopyWith<$Res> {
  __$$VoucherImplCopyWithImpl(
    _$VoucherImpl _value,
    $Res Function(_$VoucherImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Voucher
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? code = freezed,
    Object? type = freezed,
    Object? price = freezed,
    Object? branchId = freezed,
    Object? createdDate = freezed,
    Object? modifiedDate = freezed,
    Object? description = freezed,
    Object? customerId = freezed,
    Object? customerCode = freezed,
    Object? customerName = freezed,
  }) {
    return _then(
      _$VoucherImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        code: freezed == code
            ? _value.code
            : code // ignore: cast_nullable_to_non_nullable
                  as String?,
        type: freezed == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as int?,
        price: freezed == price
            ? _value.price
            : price // ignore: cast_nullable_to_non_nullable
                  as double?,
        branchId: freezed == branchId
            ? _value.branchId
            : branchId // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdDate: freezed == createdDate
            ? _value.createdDate
            : createdDate // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        modifiedDate: freezed == modifiedDate
            ? _value.modifiedDate
            : modifiedDate // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        customerId: freezed == customerId
            ? _value.customerId
            : customerId // ignore: cast_nullable_to_non_nullable
                  as String?,
        customerCode: freezed == customerCode
            ? _value.customerCode
            : customerCode // ignore: cast_nullable_to_non_nullable
                  as String?,
        customerName: freezed == customerName
            ? _value.customerName
            : customerName // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$VoucherImpl implements _Voucher {
  const _$VoucherImpl({
    @JsonKey(fromJson: _stringFromValue) required this.id,
    this.code,
    this.type,
    this.price,
    @JsonKey(fromJson: _nullableStringFromValue) this.branchId,
    this.createdDate,
    this.modifiedDate,
    this.description,
    @JsonKey(fromJson: _nullableStringFromValue) this.customerId,
    this.customerCode,
    this.customerName,
  });

  factory _$VoucherImpl.fromJson(Map<String, dynamic> json) =>
      _$$VoucherImplFromJson(json);

  @override
  @JsonKey(fromJson: _stringFromValue)
  final String id;
  @override
  final String? code;
  @override
  final int? type;
  @override
  final double? price;
  @override
  @JsonKey(fromJson: _nullableStringFromValue)
  final String? branchId;
  @override
  final DateTime? createdDate;
  @override
  final DateTime? modifiedDate;
  @override
  final String? description;
  @override
  @JsonKey(fromJson: _nullableStringFromValue)
  final String? customerId;
  @override
  final String? customerCode;
  @override
  final String? customerName;

  @override
  String toString() {
    return 'Voucher(id: $id, code: $code, type: $type, price: $price, branchId: $branchId, createdDate: $createdDate, modifiedDate: $modifiedDate, description: $description, customerId: $customerId, customerCode: $customerCode, customerName: $customerName)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VoucherImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.branchId, branchId) ||
                other.branchId == branchId) &&
            (identical(other.createdDate, createdDate) ||
                other.createdDate == createdDate) &&
            (identical(other.modifiedDate, modifiedDate) ||
                other.modifiedDate == modifiedDate) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.customerId, customerId) ||
                other.customerId == customerId) &&
            (identical(other.customerCode, customerCode) ||
                other.customerCode == customerCode) &&
            (identical(other.customerName, customerName) ||
                other.customerName == customerName));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    code,
    type,
    price,
    branchId,
    createdDate,
    modifiedDate,
    description,
    customerId,
    customerCode,
    customerName,
  );

  /// Create a copy of Voucher
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$VoucherImplCopyWith<_$VoucherImpl> get copyWith =>
      __$$VoucherImplCopyWithImpl<_$VoucherImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$VoucherImplToJson(this);
  }
}

abstract class _Voucher implements Voucher {
  const factory _Voucher({
    @JsonKey(fromJson: _stringFromValue) required final String id,
    final String? code,
    final int? type,
    final double? price,
    @JsonKey(fromJson: _nullableStringFromValue) final String? branchId,
    final DateTime? createdDate,
    final DateTime? modifiedDate,
    final String? description,
    @JsonKey(fromJson: _nullableStringFromValue) final String? customerId,
    final String? customerCode,
    final String? customerName,
  }) = _$VoucherImpl;

  factory _Voucher.fromJson(Map<String, dynamic> json) = _$VoucherImpl.fromJson;

  @override
  @JsonKey(fromJson: _stringFromValue)
  String get id;
  @override
  String? get code;
  @override
  int? get type;
  @override
  double? get price;
  @override
  @JsonKey(fromJson: _nullableStringFromValue)
  String? get branchId;
  @override
  DateTime? get createdDate;
  @override
  DateTime? get modifiedDate;
  @override
  String? get description;
  @override
  @JsonKey(fromJson: _nullableStringFromValue)
  String? get customerId;
  @override
  String? get customerCode;
  @override
  String? get customerName;

  /// Create a copy of Voucher
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$VoucherImplCopyWith<_$VoucherImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
