// To parse this JSON data, do
//
//     final allOrderList = allOrderListFromJson(jsonString);

import 'dart:convert';
// import 'dart:js_interop';

AllOrderList allOrderListFromJson(String str) => AllOrderList.fromJson(json.decode(str));

String allOrderListToJson(AllOrderList data) => json.encode(data.toJson());

class AllOrderList {
  bool isSuccess;
  String message;
  List<Orders> data;

  AllOrderList({
    required this.isSuccess,
    required this.message,
    required this.data,
  });

  factory AllOrderList.fromJson(Map<String, dynamic> json) => AllOrderList(
    isSuccess: json["isSuccess"],
    message: json["message"],
    data: List<Orders>.from(json["data"].map((x) => Orders.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "isSuccess": isSuccess,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Orders {
  String orderId;
  String merchantCode;
  String custormerName;
  String paymentMode;
  String paymentStatus;
  DateTime deliveryDate;
  DateTime expectedDelivery;
  String deliveryStatus;
  String? isAccepted;
  DateTime orderDate;
  double totalAmount;
  int totalItems;

  Orders({
    required this.orderId,
    required this.merchantCode,
    required this.custormerName,
    required this.paymentMode,
    required this.paymentStatus,
    required this.deliveryDate,
    required this.expectedDelivery,
    required this.deliveryStatus,
              this.isAccepted,
    required this.orderDate,
    required this.totalAmount,
    required this.totalItems,
  });

  factory Orders.fromJson(Map<String, dynamic> json) => Orders(
    orderId: json["orderId"],
    merchantCode: json["merchantCode"],
    custormerName: json["custormerName"],
    paymentMode: json["paymentMode"],
    paymentStatus: json["paymentStatus"],
    deliveryDate: DateTime.parse(json["deliveryDate"]),
    expectedDelivery: DateTime.parse(json["expectedDelivery"]),
    deliveryStatus: json["deliveryStatus"],
    isAccepted: (json["isAcceptance"]== null)? json["isAcceptance"]="Pending": json["isAcceptance"],
    orderDate: DateTime.parse(json["orderDate"]),
    totalAmount: json["totalAmount"],
    totalItems: json["totalItems"],
  );

  Map<String, dynamic> toJson() => {
    "orderId": orderId,
    "merchantCode": merchantCode,
    "custormerName": custormerName,
    "paymentMode": paymentMode,
    "paymentStatus": paymentStatus,
    "deliveryDate": deliveryDate.toIso8601String(),
    "expectedDelivery": expectedDelivery.toIso8601String(),
    "deliveryStatus": deliveryStatus,
    "isAcceptance": (isAccepted==null)?"Pending":isAccepted,
    "orderDate": orderDate.toIso8601String(),
    "totalAmount": totalAmount,
    "totalItems": totalItems,
  };
}
