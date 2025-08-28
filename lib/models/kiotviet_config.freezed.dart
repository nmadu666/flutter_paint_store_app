// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'kiotviet_config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

KiotvietConfig _$KiotvietConfigFromJson(Map<String, dynamic> json) {
  return _KiotvietConfig.fromJson(json);
}

/// @nodoc
mixin _$KiotvietConfig {
  String get retailer => throw _privateConstructorUsedError;
  String get clientId => throw _privateConstructorUsedError;
  String get clientSecret => throw _privateConstructorUsedError;

  /// Serializes this KiotvietConfig to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of KiotvietConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $KiotvietConfigCopyWith<KiotvietConfig> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $KiotvietConfigCopyWith<$Res> {
  factory $KiotvietConfigCopyWith(
    KiotvietConfig value,
    $Res Function(KiotvietConfig) then,
  ) = _$KiotvietConfigCopyWithImpl<$Res, KiotvietConfig>;
  @useResult
  $Res call({String retailer, String clientId, String clientSecret});
}

/// @nodoc
class _$KiotvietConfigCopyWithImpl<$Res, $Val extends KiotvietConfig>
    implements $KiotvietConfigCopyWith<$Res> {
  _$KiotvietConfigCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of KiotvietConfig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? retailer = null,
    Object? clientId = null,
    Object? clientSecret = null,
  }) {
    return _then(
      _value.copyWith(
            retailer: null == retailer
                ? _value.retailer
                : retailer // ignore: cast_nullable_to_non_nullable
                      as String,
            clientId: null == clientId
                ? _value.clientId
                : clientId // ignore: cast_nullable_to_non_nullable
                      as String,
            clientSecret: null == clientSecret
                ? _value.clientSecret
                : clientSecret // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$KiotvietConfigImplCopyWith<$Res>
    implements $KiotvietConfigCopyWith<$Res> {
  factory _$$KiotvietConfigImplCopyWith(
    _$KiotvietConfigImpl value,
    $Res Function(_$KiotvietConfigImpl) then,
  ) = __$$KiotvietConfigImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String retailer, String clientId, String clientSecret});
}

/// @nodoc
class __$$KiotvietConfigImplCopyWithImpl<$Res>
    extends _$KiotvietConfigCopyWithImpl<$Res, _$KiotvietConfigImpl>
    implements _$$KiotvietConfigImplCopyWith<$Res> {
  __$$KiotvietConfigImplCopyWithImpl(
    _$KiotvietConfigImpl _value,
    $Res Function(_$KiotvietConfigImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of KiotvietConfig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? retailer = null,
    Object? clientId = null,
    Object? clientSecret = null,
  }) {
    return _then(
      _$KiotvietConfigImpl(
        retailer: null == retailer
            ? _value.retailer
            : retailer // ignore: cast_nullable_to_non_nullable
                  as String,
        clientId: null == clientId
            ? _value.clientId
            : clientId // ignore: cast_nullable_to_non_nullable
                  as String,
        clientSecret: null == clientSecret
            ? _value.clientSecret
            : clientSecret // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$KiotvietConfigImpl implements _KiotvietConfig {
  const _$KiotvietConfigImpl({
    required this.retailer,
    required this.clientId,
    required this.clientSecret,
  });

  factory _$KiotvietConfigImpl.fromJson(Map<String, dynamic> json) =>
      _$$KiotvietConfigImplFromJson(json);

  @override
  final String retailer;
  @override
  final String clientId;
  @override
  final String clientSecret;

  @override
  String toString() {
    return 'KiotvietConfig(retailer: $retailer, clientId: $clientId, clientSecret: $clientSecret)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$KiotvietConfigImpl &&
            (identical(other.retailer, retailer) ||
                other.retailer == retailer) &&
            (identical(other.clientId, clientId) ||
                other.clientId == clientId) &&
            (identical(other.clientSecret, clientSecret) ||
                other.clientSecret == clientSecret));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, retailer, clientId, clientSecret);

  /// Create a copy of KiotvietConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$KiotvietConfigImplCopyWith<_$KiotvietConfigImpl> get copyWith =>
      __$$KiotvietConfigImplCopyWithImpl<_$KiotvietConfigImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$KiotvietConfigImplToJson(this);
  }
}

abstract class _KiotvietConfig implements KiotvietConfig {
  const factory _KiotvietConfig({
    required final String retailer,
    required final String clientId,
    required final String clientSecret,
  }) = _$KiotvietConfigImpl;

  factory _KiotvietConfig.fromJson(Map<String, dynamic> json) =
      _$KiotvietConfigImpl.fromJson;

  @override
  String get retailer;
  @override
  String get clientId;
  @override
  String get clientSecret;

  /// Create a copy of KiotvietConfig
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$KiotvietConfigImplCopyWith<_$KiotvietConfigImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
