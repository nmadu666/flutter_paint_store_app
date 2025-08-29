// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'order.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Order _$OrderFromJson(Map<String, dynamic> json) {
  return _Order.fromJson(json);
}

/// @nodoc
mixin _$Order {
  int get id => throw _privateConstructorUsedError;
  String? get code =>
      throw _privateConstructorUsedError; // Use JsonKey to map API fields to model fields if names differ.
  @JsonKey(name: 'purchaseDate')
  DateTime? get createdDate => throw _privateConstructorUsedError;
  int? get branchId => throw _privateConstructorUsedError;
  String? get branchName => throw _privateConstructorUsedError;
  int? get customerId => throw _privateConstructorUsedError;
  String? get customerName => throw _privateConstructorUsedError;
  int? get saleChannelId => throw _privateConstructorUsedError;
  String? get soldByName => throw _privateConstructorUsedError;
  String? get description =>
      throw _privateConstructorUsedError; // Financial details
  double? get total => throw _privateConstructorUsedError;
  double? get discount => throw _privateConstructorUsedError;
  double? get totalPayment =>
      throw _privateConstructorUsedError; // Trạng thái đơn hàng: 1: Hoàn thành, 2: Đang xử lý, 3: Đã huỷ
  int? get status => throw _privateConstructorUsedError;
  String? get statusValue => throw _privateConstructorUsedError; // Nested data
  List<OrderDetail> get orderDetails => throw _privateConstructorUsedError;
  List<Payment> get payments => throw _privateConstructorUsedError;
  OrderDelivery? get orderDelivery => throw _privateConstructorUsedError;

  /// Serializes this Order to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Order
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OrderCopyWith<Order> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrderCopyWith<$Res> {
  factory $OrderCopyWith(Order value, $Res Function(Order) then) =
      _$OrderCopyWithImpl<$Res, Order>;
  @useResult
  $Res call({
    int id,
    String? code,
    @JsonKey(name: 'purchaseDate') DateTime? createdDate,
    int? branchId,
    String? branchName,
    int? customerId,
    String? customerName,
    int? saleChannelId,
    String? soldByName,
    String? description,
    double? total,
    double? discount,
    double? totalPayment,
    int? status,
    String? statusValue,
    List<OrderDetail> orderDetails,
    List<Payment> payments,
    OrderDelivery? orderDelivery,
  });

  $OrderDeliveryCopyWith<$Res>? get orderDelivery;
}

/// @nodoc
class _$OrderCopyWithImpl<$Res, $Val extends Order>
    implements $OrderCopyWith<$Res> {
  _$OrderCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Order
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? code = freezed,
    Object? createdDate = freezed,
    Object? branchId = freezed,
    Object? branchName = freezed,
    Object? customerId = freezed,
    Object? customerName = freezed,
    Object? saleChannelId = freezed,
    Object? soldByName = freezed,
    Object? description = freezed,
    Object? total = freezed,
    Object? discount = freezed,
    Object? totalPayment = freezed,
    Object? status = freezed,
    Object? statusValue = freezed,
    Object? orderDetails = null,
    Object? payments = null,
    Object? orderDelivery = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            code: freezed == code
                ? _value.code
                : code // ignore: cast_nullable_to_non_nullable
                      as String?,
            createdDate: freezed == createdDate
                ? _value.createdDate
                : createdDate // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            branchId: freezed == branchId
                ? _value.branchId
                : branchId // ignore: cast_nullable_to_non_nullable
                      as int?,
            branchName: freezed == branchName
                ? _value.branchName
                : branchName // ignore: cast_nullable_to_non_nullable
                      as String?,
            customerId: freezed == customerId
                ? _value.customerId
                : customerId // ignore: cast_nullable_to_non_nullable
                      as int?,
            customerName: freezed == customerName
                ? _value.customerName
                : customerName // ignore: cast_nullable_to_non_nullable
                      as String?,
            saleChannelId: freezed == saleChannelId
                ? _value.saleChannelId
                : saleChannelId // ignore: cast_nullable_to_non_nullable
                      as int?,
            soldByName: freezed == soldByName
                ? _value.soldByName
                : soldByName // ignore: cast_nullable_to_non_nullable
                      as String?,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
            total: freezed == total
                ? _value.total
                : total // ignore: cast_nullable_to_non_nullable
                      as double?,
            discount: freezed == discount
                ? _value.discount
                : discount // ignore: cast_nullable_to_non_nullable
                      as double?,
            totalPayment: freezed == totalPayment
                ? _value.totalPayment
                : totalPayment // ignore: cast_nullable_to_non_nullable
                      as double?,
            status: freezed == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as int?,
            statusValue: freezed == statusValue
                ? _value.statusValue
                : statusValue // ignore: cast_nullable_to_non_nullable
                      as String?,
            orderDetails: null == orderDetails
                ? _value.orderDetails
                : orderDetails // ignore: cast_nullable_to_non_nullable
                      as List<OrderDetail>,
            payments: null == payments
                ? _value.payments
                : payments // ignore: cast_nullable_to_non_nullable
                      as List<Payment>,
            orderDelivery: freezed == orderDelivery
                ? _value.orderDelivery
                : orderDelivery // ignore: cast_nullable_to_non_nullable
                      as OrderDelivery?,
          )
          as $Val,
    );
  }

  /// Create a copy of Order
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $OrderDeliveryCopyWith<$Res>? get orderDelivery {
    if (_value.orderDelivery == null) {
      return null;
    }

    return $OrderDeliveryCopyWith<$Res>(_value.orderDelivery!, (value) {
      return _then(_value.copyWith(orderDelivery: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$OrderImplCopyWith<$Res> implements $OrderCopyWith<$Res> {
  factory _$$OrderImplCopyWith(
    _$OrderImpl value,
    $Res Function(_$OrderImpl) then,
  ) = __$$OrderImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    String? code,
    @JsonKey(name: 'purchaseDate') DateTime? createdDate,
    int? branchId,
    String? branchName,
    int? customerId,
    String? customerName,
    int? saleChannelId,
    String? soldByName,
    String? description,
    double? total,
    double? discount,
    double? totalPayment,
    int? status,
    String? statusValue,
    List<OrderDetail> orderDetails,
    List<Payment> payments,
    OrderDelivery? orderDelivery,
  });

  @override
  $OrderDeliveryCopyWith<$Res>? get orderDelivery;
}

/// @nodoc
class __$$OrderImplCopyWithImpl<$Res>
    extends _$OrderCopyWithImpl<$Res, _$OrderImpl>
    implements _$$OrderImplCopyWith<$Res> {
  __$$OrderImplCopyWithImpl(
    _$OrderImpl _value,
    $Res Function(_$OrderImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Order
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? code = freezed,
    Object? createdDate = freezed,
    Object? branchId = freezed,
    Object? branchName = freezed,
    Object? customerId = freezed,
    Object? customerName = freezed,
    Object? saleChannelId = freezed,
    Object? soldByName = freezed,
    Object? description = freezed,
    Object? total = freezed,
    Object? discount = freezed,
    Object? totalPayment = freezed,
    Object? status = freezed,
    Object? statusValue = freezed,
    Object? orderDetails = null,
    Object? payments = null,
    Object? orderDelivery = freezed,
  }) {
    return _then(
      _$OrderImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        code: freezed == code
            ? _value.code
            : code // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdDate: freezed == createdDate
            ? _value.createdDate
            : createdDate // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        branchId: freezed == branchId
            ? _value.branchId
            : branchId // ignore: cast_nullable_to_non_nullable
                  as int?,
        branchName: freezed == branchName
            ? _value.branchName
            : branchName // ignore: cast_nullable_to_non_nullable
                  as String?,
        customerId: freezed == customerId
            ? _value.customerId
            : customerId // ignore: cast_nullable_to_non_nullable
                  as int?,
        customerName: freezed == customerName
            ? _value.customerName
            : customerName // ignore: cast_nullable_to_non_nullable
                  as String?,
        saleChannelId: freezed == saleChannelId
            ? _value.saleChannelId
            : saleChannelId // ignore: cast_nullable_to_non_nullable
                  as int?,
        soldByName: freezed == soldByName
            ? _value.soldByName
            : soldByName // ignore: cast_nullable_to_non_nullable
                  as String?,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        total: freezed == total
            ? _value.total
            : total // ignore: cast_nullable_to_non_nullable
                  as double?,
        discount: freezed == discount
            ? _value.discount
            : discount // ignore: cast_nullable_to_non_nullable
                  as double?,
        totalPayment: freezed == totalPayment
            ? _value.totalPayment
            : totalPayment // ignore: cast_nullable_to_non_nullable
                  as double?,
        status: freezed == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as int?,
        statusValue: freezed == statusValue
            ? _value.statusValue
            : statusValue // ignore: cast_nullable_to_non_nullable
                  as String?,
        orderDetails: null == orderDetails
            ? _value._orderDetails
            : orderDetails // ignore: cast_nullable_to_non_nullable
                  as List<OrderDetail>,
        payments: null == payments
            ? _value._payments
            : payments // ignore: cast_nullable_to_non_nullable
                  as List<Payment>,
        orderDelivery: freezed == orderDelivery
            ? _value.orderDelivery
            : orderDelivery // ignore: cast_nullable_to_non_nullable
                  as OrderDelivery?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$OrderImpl implements _Order {
  const _$OrderImpl({
    required this.id,
    this.code,
    @JsonKey(name: 'purchaseDate') this.createdDate,
    this.branchId,
    this.branchName,
    this.customerId,
    this.customerName,
    this.saleChannelId,
    this.soldByName,
    this.description,
    this.total,
    this.discount,
    this.totalPayment,
    this.status,
    this.statusValue,
    final List<OrderDetail> orderDetails = const [],
    final List<Payment> payments = const [],
    this.orderDelivery,
  }) : _orderDetails = orderDetails,
       _payments = payments;

  factory _$OrderImpl.fromJson(Map<String, dynamic> json) =>
      _$$OrderImplFromJson(json);

  @override
  final int id;
  @override
  final String? code;
  // Use JsonKey to map API fields to model fields if names differ.
  @override
  @JsonKey(name: 'purchaseDate')
  final DateTime? createdDate;
  @override
  final int? branchId;
  @override
  final String? branchName;
  @override
  final int? customerId;
  @override
  final String? customerName;
  @override
  final int? saleChannelId;
  @override
  final String? soldByName;
  @override
  final String? description;
  // Financial details
  @override
  final double? total;
  @override
  final double? discount;
  @override
  final double? totalPayment;
  // Trạng thái đơn hàng: 1: Hoàn thành, 2: Đang xử lý, 3: Đã huỷ
  @override
  final int? status;
  @override
  final String? statusValue;
  // Nested data
  final List<OrderDetail> _orderDetails;
  // Nested data
  @override
  @JsonKey()
  List<OrderDetail> get orderDetails {
    if (_orderDetails is EqualUnmodifiableListView) return _orderDetails;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_orderDetails);
  }

  final List<Payment> _payments;
  @override
  @JsonKey()
  List<Payment> get payments {
    if (_payments is EqualUnmodifiableListView) return _payments;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_payments);
  }

  @override
  final OrderDelivery? orderDelivery;

  @override
  String toString() {
    return 'Order(id: $id, code: $code, createdDate: $createdDate, branchId: $branchId, branchName: $branchName, customerId: $customerId, customerName: $customerName, saleChannelId: $saleChannelId, soldByName: $soldByName, description: $description, total: $total, discount: $discount, totalPayment: $totalPayment, status: $status, statusValue: $statusValue, orderDetails: $orderDetails, payments: $payments, orderDelivery: $orderDelivery)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrderImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.createdDate, createdDate) ||
                other.createdDate == createdDate) &&
            (identical(other.branchId, branchId) ||
                other.branchId == branchId) &&
            (identical(other.branchName, branchName) ||
                other.branchName == branchName) &&
            (identical(other.customerId, customerId) ||
                other.customerId == customerId) &&
            (identical(other.customerName, customerName) ||
                other.customerName == customerName) &&
            (identical(other.saleChannelId, saleChannelId) ||
                other.saleChannelId == saleChannelId) &&
            (identical(other.soldByName, soldByName) ||
                other.soldByName == soldByName) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.total, total) || other.total == total) &&
            (identical(other.discount, discount) ||
                other.discount == discount) &&
            (identical(other.totalPayment, totalPayment) ||
                other.totalPayment == totalPayment) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.statusValue, statusValue) ||
                other.statusValue == statusValue) &&
            const DeepCollectionEquality().equals(
              other._orderDetails,
              _orderDetails,
            ) &&
            const DeepCollectionEquality().equals(other._payments, _payments) &&
            (identical(other.orderDelivery, orderDelivery) ||
                other.orderDelivery == orderDelivery));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    code,
    createdDate,
    branchId,
    branchName,
    customerId,
    customerName,
    saleChannelId,
    soldByName,
    description,
    total,
    discount,
    totalPayment,
    status,
    statusValue,
    const DeepCollectionEquality().hash(_orderDetails),
    const DeepCollectionEquality().hash(_payments),
    orderDelivery,
  );

  /// Create a copy of Order
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OrderImplCopyWith<_$OrderImpl> get copyWith =>
      __$$OrderImplCopyWithImpl<_$OrderImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OrderImplToJson(this);
  }
}

abstract class _Order implements Order {
  const factory _Order({
    required final int id,
    final String? code,
    @JsonKey(name: 'purchaseDate') final DateTime? createdDate,
    final int? branchId,
    final String? branchName,
    final int? customerId,
    final String? customerName,
    final int? saleChannelId,
    final String? soldByName,
    final String? description,
    final double? total,
    final double? discount,
    final double? totalPayment,
    final int? status,
    final String? statusValue,
    final List<OrderDetail> orderDetails,
    final List<Payment> payments,
    final OrderDelivery? orderDelivery,
  }) = _$OrderImpl;

  factory _Order.fromJson(Map<String, dynamic> json) = _$OrderImpl.fromJson;

  @override
  int get id;
  @override
  String? get code; // Use JsonKey to map API fields to model fields if names differ.
  @override
  @JsonKey(name: 'purchaseDate')
  DateTime? get createdDate;
  @override
  int? get branchId;
  @override
  String? get branchName;
  @override
  int? get customerId;
  @override
  String? get customerName;
  @override
  int? get saleChannelId;
  @override
  String? get soldByName;
  @override
  String? get description; // Financial details
  @override
  double? get total;
  @override
  double? get discount;
  @override
  double? get totalPayment; // Trạng thái đơn hàng: 1: Hoàn thành, 2: Đang xử lý, 3: Đã huỷ
  @override
  int? get status;
  @override
  String? get statusValue; // Nested data
  @override
  List<OrderDetail> get orderDetails;
  @override
  List<Payment> get payments;
  @override
  OrderDelivery? get orderDelivery;

  /// Create a copy of Order
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OrderImplCopyWith<_$OrderImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

OrderDetail _$OrderDetailFromJson(Map<String, dynamic> json) {
  return _OrderDetail.fromJson(json);
}

/// @nodoc
mixin _$OrderDetail {
  int get productId => throw _privateConstructorUsedError;
  String? get productCode => throw _privateConstructorUsedError;
  String? get productName => throw _privateConstructorUsedError;
  String? get note => throw _privateConstructorUsedError;
  double get quantity => throw _privateConstructorUsedError;
  double? get price =>
      throw _privateConstructorUsedError; // Discount for this specific line item
  double? get discount => throw _privateConstructorUsedError;
  int? get priceBookId => throw _privateConstructorUsedError;

  /// Serializes this OrderDetail to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of OrderDetail
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OrderDetailCopyWith<OrderDetail> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrderDetailCopyWith<$Res> {
  factory $OrderDetailCopyWith(
    OrderDetail value,
    $Res Function(OrderDetail) then,
  ) = _$OrderDetailCopyWithImpl<$Res, OrderDetail>;
  @useResult
  $Res call({
    int productId,
    String? productCode,
    String? productName,
    String? note,
    double quantity,
    double? price,
    double? discount,
    int? priceBookId,
  });
}

/// @nodoc
class _$OrderDetailCopyWithImpl<$Res, $Val extends OrderDetail>
    implements $OrderDetailCopyWith<$Res> {
  _$OrderDetailCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OrderDetail
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? productId = null,
    Object? productCode = freezed,
    Object? productName = freezed,
    Object? note = freezed,
    Object? quantity = null,
    Object? price = freezed,
    Object? discount = freezed,
    Object? priceBookId = freezed,
  }) {
    return _then(
      _value.copyWith(
            productId: null == productId
                ? _value.productId
                : productId // ignore: cast_nullable_to_non_nullable
                      as int,
            productCode: freezed == productCode
                ? _value.productCode
                : productCode // ignore: cast_nullable_to_non_nullable
                      as String?,
            productName: freezed == productName
                ? _value.productName
                : productName // ignore: cast_nullable_to_non_nullable
                      as String?,
            note: freezed == note
                ? _value.note
                : note // ignore: cast_nullable_to_non_nullable
                      as String?,
            quantity: null == quantity
                ? _value.quantity
                : quantity // ignore: cast_nullable_to_non_nullable
                      as double,
            price: freezed == price
                ? _value.price
                : price // ignore: cast_nullable_to_non_nullable
                      as double?,
            discount: freezed == discount
                ? _value.discount
                : discount // ignore: cast_nullable_to_non_nullable
                      as double?,
            priceBookId: freezed == priceBookId
                ? _value.priceBookId
                : priceBookId // ignore: cast_nullable_to_non_nullable
                      as int?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$OrderDetailImplCopyWith<$Res>
    implements $OrderDetailCopyWith<$Res> {
  factory _$$OrderDetailImplCopyWith(
    _$OrderDetailImpl value,
    $Res Function(_$OrderDetailImpl) then,
  ) = __$$OrderDetailImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int productId,
    String? productCode,
    String? productName,
    String? note,
    double quantity,
    double? price,
    double? discount,
    int? priceBookId,
  });
}

/// @nodoc
class __$$OrderDetailImplCopyWithImpl<$Res>
    extends _$OrderDetailCopyWithImpl<$Res, _$OrderDetailImpl>
    implements _$$OrderDetailImplCopyWith<$Res> {
  __$$OrderDetailImplCopyWithImpl(
    _$OrderDetailImpl _value,
    $Res Function(_$OrderDetailImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of OrderDetail
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? productId = null,
    Object? productCode = freezed,
    Object? productName = freezed,
    Object? note = freezed,
    Object? quantity = null,
    Object? price = freezed,
    Object? discount = freezed,
    Object? priceBookId = freezed,
  }) {
    return _then(
      _$OrderDetailImpl(
        productId: null == productId
            ? _value.productId
            : productId // ignore: cast_nullable_to_non_nullable
                  as int,
        productCode: freezed == productCode
            ? _value.productCode
            : productCode // ignore: cast_nullable_to_non_nullable
                  as String?,
        productName: freezed == productName
            ? _value.productName
            : productName // ignore: cast_nullable_to_non_nullable
                  as String?,
        note: freezed == note
            ? _value.note
            : note // ignore: cast_nullable_to_non_nullable
                  as String?,
        quantity: null == quantity
            ? _value.quantity
            : quantity // ignore: cast_nullable_to_non_nullable
                  as double,
        price: freezed == price
            ? _value.price
            : price // ignore: cast_nullable_to_non_nullable
                  as double?,
        discount: freezed == discount
            ? _value.discount
            : discount // ignore: cast_nullable_to_non_nullable
                  as double?,
        priceBookId: freezed == priceBookId
            ? _value.priceBookId
            : priceBookId // ignore: cast_nullable_to_non_nullable
                  as int?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$OrderDetailImpl implements _OrderDetail {
  const _$OrderDetailImpl({
    required this.productId,
    this.productCode,
    this.productName,
    this.note,
    required this.quantity,
    this.price,
    this.discount,
    this.priceBookId,
  });

  factory _$OrderDetailImpl.fromJson(Map<String, dynamic> json) =>
      _$$OrderDetailImplFromJson(json);

  @override
  final int productId;
  @override
  final String? productCode;
  @override
  final String? productName;
  @override
  final String? note;
  @override
  final double quantity;
  @override
  final double? price;
  // Discount for this specific line item
  @override
  final double? discount;
  @override
  final int? priceBookId;

  @override
  String toString() {
    return 'OrderDetail(productId: $productId, productCode: $productCode, productName: $productName, note: $note, quantity: $quantity, price: $price, discount: $discount, priceBookId: $priceBookId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrderDetailImpl &&
            (identical(other.productId, productId) ||
                other.productId == productId) &&
            (identical(other.productCode, productCode) ||
                other.productCode == productCode) &&
            (identical(other.productName, productName) ||
                other.productName == productName) &&
            (identical(other.note, note) || other.note == note) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.discount, discount) ||
                other.discount == discount) &&
            (identical(other.priceBookId, priceBookId) ||
                other.priceBookId == priceBookId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    productId,
    productCode,
    productName,
    note,
    quantity,
    price,
    discount,
    priceBookId,
  );

  /// Create a copy of OrderDetail
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OrderDetailImplCopyWith<_$OrderDetailImpl> get copyWith =>
      __$$OrderDetailImplCopyWithImpl<_$OrderDetailImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OrderDetailImplToJson(this);
  }
}

abstract class _OrderDetail implements OrderDetail {
  const factory _OrderDetail({
    required final int productId,
    final String? productCode,
    final String? productName,
    final String? note,
    required final double quantity,
    final double? price,
    final double? discount,
    final int? priceBookId,
  }) = _$OrderDetailImpl;

  factory _OrderDetail.fromJson(Map<String, dynamic> json) =
      _$OrderDetailImpl.fromJson;

  @override
  int get productId;
  @override
  String? get productCode;
  @override
  String? get productName;
  @override
  String? get note;
  @override
  double get quantity;
  @override
  double? get price; // Discount for this specific line item
  @override
  double? get discount;
  @override
  int? get priceBookId;

  /// Create a copy of OrderDetail
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OrderDetailImplCopyWith<_$OrderDetailImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Payment _$PaymentFromJson(Map<String, dynamic> json) {
  return _Payment.fromJson(json);
}

/// @nodoc
mixin _$Payment {
  String? get method => throw _privateConstructorUsedError;
  double? get amount => throw _privateConstructorUsedError;
  String? get statusValue => throw _privateConstructorUsedError;

  /// Serializes this Payment to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Payment
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PaymentCopyWith<Payment> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PaymentCopyWith<$Res> {
  factory $PaymentCopyWith(Payment value, $Res Function(Payment) then) =
      _$PaymentCopyWithImpl<$Res, Payment>;
  @useResult
  $Res call({String? method, double? amount, String? statusValue});
}

/// @nodoc
class _$PaymentCopyWithImpl<$Res, $Val extends Payment>
    implements $PaymentCopyWith<$Res> {
  _$PaymentCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Payment
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? method = freezed,
    Object? amount = freezed,
    Object? statusValue = freezed,
  }) {
    return _then(
      _value.copyWith(
            method: freezed == method
                ? _value.method
                : method // ignore: cast_nullable_to_non_nullable
                      as String?,
            amount: freezed == amount
                ? _value.amount
                : amount // ignore: cast_nullable_to_non_nullable
                      as double?,
            statusValue: freezed == statusValue
                ? _value.statusValue
                : statusValue // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PaymentImplCopyWith<$Res> implements $PaymentCopyWith<$Res> {
  factory _$$PaymentImplCopyWith(
    _$PaymentImpl value,
    $Res Function(_$PaymentImpl) then,
  ) = __$$PaymentImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? method, double? amount, String? statusValue});
}

/// @nodoc
class __$$PaymentImplCopyWithImpl<$Res>
    extends _$PaymentCopyWithImpl<$Res, _$PaymentImpl>
    implements _$$PaymentImplCopyWith<$Res> {
  __$$PaymentImplCopyWithImpl(
    _$PaymentImpl _value,
    $Res Function(_$PaymentImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Payment
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? method = freezed,
    Object? amount = freezed,
    Object? statusValue = freezed,
  }) {
    return _then(
      _$PaymentImpl(
        method: freezed == method
            ? _value.method
            : method // ignore: cast_nullable_to_non_nullable
                  as String?,
        amount: freezed == amount
            ? _value.amount
            : amount // ignore: cast_nullable_to_non_nullable
                  as double?,
        statusValue: freezed == statusValue
            ? _value.statusValue
            : statusValue // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PaymentImpl implements _Payment {
  const _$PaymentImpl({this.method, this.amount, this.statusValue});

  factory _$PaymentImpl.fromJson(Map<String, dynamic> json) =>
      _$$PaymentImplFromJson(json);

  @override
  final String? method;
  @override
  final double? amount;
  @override
  final String? statusValue;

  @override
  String toString() {
    return 'Payment(method: $method, amount: $amount, statusValue: $statusValue)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PaymentImpl &&
            (identical(other.method, method) || other.method == method) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.statusValue, statusValue) ||
                other.statusValue == statusValue));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, method, amount, statusValue);

  /// Create a copy of Payment
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PaymentImplCopyWith<_$PaymentImpl> get copyWith =>
      __$$PaymentImplCopyWithImpl<_$PaymentImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PaymentImplToJson(this);
  }
}

abstract class _Payment implements Payment {
  const factory _Payment({
    final String? method,
    final double? amount,
    final String? statusValue,
  }) = _$PaymentImpl;

  factory _Payment.fromJson(Map<String, dynamic> json) = _$PaymentImpl.fromJson;

  @override
  String? get method;
  @override
  double? get amount;
  @override
  String? get statusValue;

  /// Create a copy of Payment
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PaymentImplCopyWith<_$PaymentImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

OrderDelivery _$OrderDeliveryFromJson(Map<String, dynamic> json) {
  return _OrderDelivery.fromJson(json);
}

/// @nodoc
mixin _$OrderDelivery {
  String? get receiver => throw _privateConstructorUsedError;
  String? get contactNumber => throw _privateConstructorUsedError;
  String? get address => throw _privateConstructorUsedError;
  double? get price => throw _privateConstructorUsedError;
  String? get deliveryCode => throw _privateConstructorUsedError;

  /// Serializes this OrderDelivery to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of OrderDelivery
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OrderDeliveryCopyWith<OrderDelivery> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrderDeliveryCopyWith<$Res> {
  factory $OrderDeliveryCopyWith(
    OrderDelivery value,
    $Res Function(OrderDelivery) then,
  ) = _$OrderDeliveryCopyWithImpl<$Res, OrderDelivery>;
  @useResult
  $Res call({
    String? receiver,
    String? contactNumber,
    String? address,
    double? price,
    String? deliveryCode,
  });
}

/// @nodoc
class _$OrderDeliveryCopyWithImpl<$Res, $Val extends OrderDelivery>
    implements $OrderDeliveryCopyWith<$Res> {
  _$OrderDeliveryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OrderDelivery
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? receiver = freezed,
    Object? contactNumber = freezed,
    Object? address = freezed,
    Object? price = freezed,
    Object? deliveryCode = freezed,
  }) {
    return _then(
      _value.copyWith(
            receiver: freezed == receiver
                ? _value.receiver
                : receiver // ignore: cast_nullable_to_non_nullable
                      as String?,
            contactNumber: freezed == contactNumber
                ? _value.contactNumber
                : contactNumber // ignore: cast_nullable_to_non_nullable
                      as String?,
            address: freezed == address
                ? _value.address
                : address // ignore: cast_nullable_to_non_nullable
                      as String?,
            price: freezed == price
                ? _value.price
                : price // ignore: cast_nullable_to_non_nullable
                      as double?,
            deliveryCode: freezed == deliveryCode
                ? _value.deliveryCode
                : deliveryCode // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$OrderDeliveryImplCopyWith<$Res>
    implements $OrderDeliveryCopyWith<$Res> {
  factory _$$OrderDeliveryImplCopyWith(
    _$OrderDeliveryImpl value,
    $Res Function(_$OrderDeliveryImpl) then,
  ) = __$$OrderDeliveryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String? receiver,
    String? contactNumber,
    String? address,
    double? price,
    String? deliveryCode,
  });
}

/// @nodoc
class __$$OrderDeliveryImplCopyWithImpl<$Res>
    extends _$OrderDeliveryCopyWithImpl<$Res, _$OrderDeliveryImpl>
    implements _$$OrderDeliveryImplCopyWith<$Res> {
  __$$OrderDeliveryImplCopyWithImpl(
    _$OrderDeliveryImpl _value,
    $Res Function(_$OrderDeliveryImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of OrderDelivery
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? receiver = freezed,
    Object? contactNumber = freezed,
    Object? address = freezed,
    Object? price = freezed,
    Object? deliveryCode = freezed,
  }) {
    return _then(
      _$OrderDeliveryImpl(
        receiver: freezed == receiver
            ? _value.receiver
            : receiver // ignore: cast_nullable_to_non_nullable
                  as String?,
        contactNumber: freezed == contactNumber
            ? _value.contactNumber
            : contactNumber // ignore: cast_nullable_to_non_nullable
                  as String?,
        address: freezed == address
            ? _value.address
            : address // ignore: cast_nullable_to_non_nullable
                  as String?,
        price: freezed == price
            ? _value.price
            : price // ignore: cast_nullable_to_non_nullable
                  as double?,
        deliveryCode: freezed == deliveryCode
            ? _value.deliveryCode
            : deliveryCode // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$OrderDeliveryImpl implements _OrderDelivery {
  const _$OrderDeliveryImpl({
    this.receiver,
    this.contactNumber,
    this.address,
    this.price,
    this.deliveryCode,
  });

  factory _$OrderDeliveryImpl.fromJson(Map<String, dynamic> json) =>
      _$$OrderDeliveryImplFromJson(json);

  @override
  final String? receiver;
  @override
  final String? contactNumber;
  @override
  final String? address;
  @override
  final double? price;
  @override
  final String? deliveryCode;

  @override
  String toString() {
    return 'OrderDelivery(receiver: $receiver, contactNumber: $contactNumber, address: $address, price: $price, deliveryCode: $deliveryCode)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrderDeliveryImpl &&
            (identical(other.receiver, receiver) ||
                other.receiver == receiver) &&
            (identical(other.contactNumber, contactNumber) ||
                other.contactNumber == contactNumber) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.deliveryCode, deliveryCode) ||
                other.deliveryCode == deliveryCode));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    receiver,
    contactNumber,
    address,
    price,
    deliveryCode,
  );

  /// Create a copy of OrderDelivery
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OrderDeliveryImplCopyWith<_$OrderDeliveryImpl> get copyWith =>
      __$$OrderDeliveryImplCopyWithImpl<_$OrderDeliveryImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OrderDeliveryImplToJson(this);
  }
}

abstract class _OrderDelivery implements OrderDelivery {
  const factory _OrderDelivery({
    final String? receiver,
    final String? contactNumber,
    final String? address,
    final double? price,
    final String? deliveryCode,
  }) = _$OrderDeliveryImpl;

  factory _OrderDelivery.fromJson(Map<String, dynamic> json) =
      _$OrderDeliveryImpl.fromJson;

  @override
  String? get receiver;
  @override
  String? get contactNumber;
  @override
  String? get address;
  @override
  double? get price;
  @override
  String? get deliveryCode;

  /// Create a copy of OrderDelivery
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OrderDeliveryImplCopyWith<_$OrderDeliveryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
