// To parse this JSON data, do
//
//     final orderDetails = orderDetailsFromJson(jsonString);

import 'dart:convert';

OrderDetails orderDetailsFromJson(String str) => OrderDetails.fromJson(json.decode(str));

String orderDetailsToJson(OrderDetails data) => json.encode(data.toJson());

class OrderDetails {
  bool isSuccess;
  String message;
  OrderInformation? data;

  OrderDetails({
    required this.isSuccess,
    required this.message,
     this.data,
  });

  factory OrderDetails.fromJson(Map<String, dynamic> json) => OrderDetails(
    isSuccess: json["isSuccess"],
    message: json["message"],
    data: OrderInformation.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "isSuccess": isSuccess,
    "message": message,
    "data": data?.toJson(),
  };
}

class OrderInformation {
  String orderId;
  int paymentMode;
  int paymentStatus;
  DateTime orderDate;
  DateTime deliveryDate;
  DateTime expectedDelivery;
  int acceptance;
  DateTime acceptanceDateTime;
  String deliveryStatus;
  Buyer buyer;
  List<OrderItems> items;
  double orderTotalAmount;

  OrderInformation({
    required this.orderId,
    required this.paymentMode,
    required this.paymentStatus,
    required this.orderDate,
    required this.deliveryDate,
    required this.expectedDelivery,
    required this.acceptance,
    required this.acceptanceDateTime,
    required this.deliveryStatus,
    required this.buyer,
    required this.items,
    required this.orderTotalAmount,
  });

  factory OrderInformation.fromJson(Map<String, dynamic> json) => OrderInformation(
    orderId: json["orderId"],
    paymentMode: json["paymentMode"],
    paymentStatus: json["paymentStatus"],
    orderDate: DateTime.parse(json["orderDate"]),
    deliveryDate: DateTime.parse(json["deliveryDate"]),
    expectedDelivery: DateTime.parse(json["expectedDelivery"]),
    acceptance: json["acceptance"],
    acceptanceDateTime: DateTime.parse(json["acceptanceDateTime"]),
    deliveryStatus: json["deliveryStatus"],
    buyer: Buyer.fromJson(json["buyer"]),
    items: List<OrderItems>.from(json["items"].map((x) => OrderItems.fromJson(x))),
    orderTotalAmount: json["orderTotalAmount"],
  );

  Map<String, dynamic> toJson() => {
    "orderId": orderId,
    "paymentMode": paymentMode,
    "paymentStatus": paymentStatus,
    "orderDate": orderDate.toIso8601String(),
    "deliveryDate": deliveryDate.toIso8601String(),
    "expectedDelivery": expectedDelivery.toIso8601String(),
    "acceptance": acceptance,
    "acceptanceDateTime": acceptanceDateTime.toIso8601String(),
    "deliveryStatus": deliveryStatus,
    "buyer": buyer.toJson(),
    "items": List<dynamic>.from(items.map((x) => x.toJson())),
    "orderTotalAmount": orderTotalAmount,
  };
}

class Buyer {
  String name;
  String phoneNumber;
  String emailAddress;
  String address;

  Buyer({
    required this.name,
    required this.phoneNumber,
    required this.emailAddress,
    required this.address,
  });

  factory Buyer.fromJson(Map<String, dynamic> json) => Buyer(
    name: json["name"],
    phoneNumber: json["phoneNumber"],
    emailAddress: json["emailAddress"],
    address: json["address"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "phoneNumber": phoneNumber,
    "emailAddress": emailAddress,
    "address": address,
  };
}

class OrderItems {
  String productImage;
  String productName;
  String name;
  String  paymentStatus;
  int quantity;
  double sellingPrice;
  double totalSales;

  OrderItems({
    required this.productImage,
    required this.productName,
    required this.name,
    required this.paymentStatus,
    required this.quantity,
    required this.sellingPrice,
    required this.totalSales,
  });

  factory OrderItems.fromJson(Map<String, dynamic> json) => OrderItems(
    productImage: json["productImage"],
    productName: json["productName"],
    name: json["name"],
    paymentStatus: json["paymentStatus"],
    quantity: json["quantity"],
    sellingPrice: json["sellingPrice"],
    totalSales: json["totalSales"],
  );

  Map<String, dynamic> toJson() => {
    "productImage": productImage,
    "productName": productName,
    "name": name,
    "paymentStatus": paymentStatus,
    "quantity": quantity,
    "sellingPrice": sellingPrice,
    "totalSales": totalSales,
  };
}
