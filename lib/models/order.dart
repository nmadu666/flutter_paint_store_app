import 'package:freezed_annotation/freezed_annotation.dart';

part 'order.freezed.dart';
part 'order.g.dart';

/// Represents a detailed order from the KiotViet API.
/// This model is designed to be comprehensive for detail views.
@freezed
class Order with _$Order {
  const factory Order({
    required int id,
    String? code,
    // Use JsonKey to map API fields to model fields if names differ.
    @JsonKey(name: 'purchaseDate') DateTime? createdDate,
    int? branchId,
    String? branchName,
    int? customerId,
    String? customerName,
    int? saleChannelId,
    String? soldByName,
    String? description,

    // Financial details
    double? total,
    double? discount,
    double? totalPayment,

    // Trạng thái đơn hàng: 1: Hoàn thành, 2: Đang xử lý, 3: Đã huỷ
    int? status,
    String? statusValue,

    // Nested data
    @Default([]) List<OrderDetail> orderDetails,
    @Default([]) List<Payment> payments,
    OrderDelivery? orderDelivery,
  }) = _Order;

  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);
}

/// Represents a single line item within an order.
@freezed
class OrderDetail with _$OrderDetail {
  const factory OrderDetail({
    required int productId,
    String? productCode,
    String? productName,
    String? note,
    required double quantity,
    double? price,
    // Discount for this specific line item
    double? discount,
    int? priceBookId,
  }) = _OrderDetail;

  factory OrderDetail.fromJson(Map<String, dynamic> json) =>
      _$OrderDetailFromJson(json);
}

/// Represents a payment transaction associated with an order.
@freezed
class Payment with _$Payment {
  const factory Payment({String? method, double? amount, String? statusValue}) =
      _Payment;

  factory Payment.fromJson(Map<String, dynamic> json) =>
      _$PaymentFromJson(json);
}

/// Represents delivery information for an order.
@freezed
class OrderDelivery with _$OrderDelivery {
  const factory OrderDelivery({
    String? receiver,
    String? contactNumber,
    String? address,
    double? price,
    String? deliveryCode,
  }) = _OrderDelivery;

  factory OrderDelivery.fromJson(Map<String, dynamic> json) =>
      _$OrderDeliveryFromJson(json);
}
