class Order {
  final int? id;
  final String? code;
  final DateTime? purchaseDate;
  final int? branchId;
  final String? branchName;
  final int? customerId;
  final String? customerName;
  final num? total;
  final num? totalPayment;
  final num? discountRatio;
  final num? discount;
  final int? status;
  final String? statusValue;
  final String? description;
  final bool? usingCod;
  final int? retailerId;
  final DateTime? modifiedDate;
  final DateTime? createdDate;
  final List<Payment>? payments;
  final List<OrderDetail>? orderDetails;
  final OrderDelivery? orderDelivery;
  final List<dynamic>? invoiceOrderSurcharges;

  Order({
    this.id,
    this.code,
    this.purchaseDate,
    this.branchId,
    this.branchName,
    this.customerId,
    this.customerName,
    this.total,
    this.totalPayment,
    this.discountRatio,
    this.discount,
    this.status,
    this.statusValue,
    this.description,
    this.usingCod,
    this.retailerId,
    this.modifiedDate,
    this.createdDate,
    this.payments,
    this.orderDetails,
    this.orderDelivery,
    this.invoiceOrderSurcharges,
  });

  factory Order.fromJson(Map<String, dynamic> json) => Order(
    id: json["id"],
    code: json["code"],
    purchaseDate: json["purchaseDate"] == null
        ? null
        : DateTime.parse(json["purchaseDate"]),
    branchId: json["branchId"],
    branchName: json["branchName"],
    customerId: json["customerId"],
    customerName: json["customerName"],
    total: json["total"],
    totalPayment: json["totalPayment"],
    discountRatio: json["discountRatio"],
    discount: json["discount"],
    status: json["status"],
    statusValue: json["statusValue"],
    description: json["description"],
    usingCod: json["usingCod"],
    retailerId: json["retailerId"],
    modifiedDate: json["modifiedDate"] == null
        ? null
        : DateTime.parse(json["modifiedDate"]),
    createdDate: json["createdDate"] == null
        ? null
        : DateTime.parse(json["createdDate"]),
    payments: json["payments"] == null
        ? []
        : List<Payment>.from(json["payments"]!.map((x) => Payment.fromJson(x))),
    orderDetails: json["orderDetails"] == null
        ? []
        : List<OrderDetail>.from(
            json["orderDetails"]!.map((x) => OrderDetail.fromJson(x)),
          ),
    orderDelivery: json["orderDelivery"] == null
        ? null
        : OrderDelivery.fromJson(json["orderDelivery"]),
    invoiceOrderSurcharges: json["invoiceOrderSurcharges"] == null
        ? []
        : List<dynamic>.from(json["invoiceOrderSurcharges"]!.map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "code": code,
    "purchaseDate": purchaseDate?.toIso8601String(),
    "branchId": branchId,
    "branchName": branchName,
    "customerId": customerId,
    "customerName": customerName,
    "total": total,
    "totalPayment": totalPayment,
    "discountRatio": discountRatio,
    "discount": discount,
    "status": status,
    "statusValue": statusValue,
    "description": description,
    "usingCod": usingCod,
    "retailerId": retailerId,
    "modifiedDate": modifiedDate?.toIso8601String(),
    "createdDate": createdDate?.toIso8601String(),
    "payments": payments == null
        ? []
        : List<dynamic>.from(payments!.map((x) => x.toJson())),
    "orderDetails": orderDetails == null
        ? []
        : List<dynamic>.from(orderDetails!.map((x) => x.toJson())),
    "orderDelivery": orderDelivery?.toJson(),
    "invoiceOrderSurcharges": invoiceOrderSurcharges == null
        ? []
        : List<dynamic>.from(invoiceOrderSurcharges!.map((x) => x)),
  };
}

class OrderDetail {
  final int? productId;
  final String? productCode;
  final String? productName;
  final num? quantity;
  final num? price;
  final num? discountRatio;
  final num? discount;
  final String? note;
  final bool? isMaster;

  OrderDetail({
    this.productId,
    this.productCode,
    this.productName,
    this.quantity,
    this.price,
    this.discountRatio,
    this.discount,
    this.note,
    this.isMaster,
  });

  factory OrderDetail.fromJson(Map<String, dynamic> json) => OrderDetail(
    productId: json["productId"],
    productCode: json["productCode"],
    productName: json["productName"],
    quantity: json["quantity"],
    price: json["price"],
    discountRatio: json["discountRatio"],
    discount: json["discount"],
    note: json["note"],
    isMaster: json["isMaster"],
  );

  Map<String, dynamic> toJson() => {
    "productId": productId,
    "productCode": productCode,
    "productName": productName,
    "quantity": quantity,
    "price": price,
    "discountRatio": discountRatio,
    "discount": discount,
    "note": note,
    "isMaster": isMaster,
  };
}

class OrderDelivery {
  final String? deliveryCode;
  final String? type;
  final num? price;
  final String? receiver;
  final String? contactNumber;
  final String? address;
  final int? locationId;
  final String? locationName;
  final num? weight;
  final num? length;
  final num? width;
  final num? height;
  final int? partnerDeliveryId;
  final dynamic partnerDelivery;

  OrderDelivery({
    this.deliveryCode,
    this.type,
    this.price,
    this.receiver,
    this.contactNumber,
    this.address,
    this.locationId,
    this.locationName,
    this.weight,
    this.length,
    this.width,
    this.height,
    this.partnerDeliveryId,
    this.partnerDelivery,
  });

  factory OrderDelivery.fromJson(Map<String, dynamic> json) => OrderDelivery(
    deliveryCode: json["deliveryCode"],
    type: json["type"],
    price: json["price"],
    receiver: json["receiver"],
    contactNumber: json["contactNumber"],
    address: json["address"],
    locationId: json["locationId"],
    locationName: json["locationName"],
    weight: json["weight"],
    length: json["length"],
    width: json["width"],
    height: json["height"],
    partnerDeliveryId: json["partnerDeliveryId"],
    partnerDelivery: json["partnerDelivery"],
  );

  Map<String, dynamic> toJson() => {
    "deliveryCode": deliveryCode,
    "type": type,
    "price": price,
    "receiver": receiver,
    "contactNumber": contactNumber,
    "address": address,
    "locationId": locationId,
    "locationName": locationName,
    "weight": weight,
    "length": length,
    "width": width,
    "height": height,
    "partnerDeliveryId": partnerDeliveryId,
    "partnerDelivery": partnerDelivery,
  };
}

class Payment {
  final int? id;
  final String? code;
  final num? amount;
  final String? method;
  final int? status;
  final DateTime? transDate;
  final String? bankAccount;
  final int? accountId;

  Payment({
    this.id,
    this.code,
    this.amount,
    this.method,
    this.status,
    this.transDate,
    this.bankAccount,
    this.accountId,
  });

  factory Payment.fromJson(Map<String, dynamic> json) => Payment(
    id: json["id"],
    code: json["code"],
    amount: json["amount"],
    method: json["method"],
    status: json["status"],
    transDate: json["transDate"] == null
        ? null
        : DateTime.parse(json["transDate"]),
    bankAccount: json["bankAccount"],
    accountId: json["accountId"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "code": code,
    "amount": amount,
    "method": method,
    "status": status,
    "transDate": transDate?.toIso8601String(),
    "bankAccount": bankAccount,
    "accountId": accountId,
  };
}
