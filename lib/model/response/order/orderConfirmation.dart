// To parse this JSON data, do
//
//     final orderConfirmation = orderConfirmationFromJson(jsonString);

import 'dart:convert';

OrderConfirmation orderConfirmationFromJson(String str) => OrderConfirmation.fromJson(json.decode(str));

String orderConfirmationToJson(OrderConfirmation data) => json.encode(data.toJson());

class OrderConfirmation {
  String orderId;
  String merchantCode;
  bool isAccept;

  OrderConfirmation({
    required this.orderId,
    required this.merchantCode,
    required this.isAccept,
  });

  factory OrderConfirmation.fromJson(Map<String, dynamic> json) => OrderConfirmation(
    orderId: json["orderId"],
    merchantCode: json["merchantCode"],
    isAccept: json["isAccept"],
  );

  Map<String, dynamic> toJson() => {
    "orderId": orderId,
    "merchantCode": merchantCode,
    "isAccept": isAccept,
  };
}
