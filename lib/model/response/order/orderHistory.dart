// To parse this JSON data, do
//
//     final orderHistory = orderHistoryFromJson(jsonString);

import 'dart:convert';

List<HistoryOrder> orderHistoryFromJson(String str) => List<HistoryOrder>.from(json.decode(str).map((x) => HistoryOrder.fromJson(x)));

String orderHistoryToJson(List<HistoryOrder> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class HistoryOrder {
  int id;
  String orderId;
  String customerName;
  double salesAmount;
  DateTime timeStamp;
  DateTime createdOn;
  int itemCount;
  String paymentStatus;
  String deliveryStatus;
  String isAcceptance;
  Buyer buyer;

  HistoryOrder({
    required this.id,
    required this.customerName,
    required this.salesAmount,
    required this.timeStamp,
    required this.createdOn,
    required this.itemCount,
    required this.deliveryStatus,
    required this.isAcceptance,
    required this.paymentStatus,
    required this.orderId,
    required this.buyer,
  });

  factory HistoryOrder.fromJson(Map<String, dynamic> json) => HistoryOrder(
    id: json["id"],
    customerName: json["customerName"],
    salesAmount: json["salesAmount"],
    timeStamp: DateTime.parse(json["timeStamp"]),
    createdOn: DateTime.parse(json["createdOn"]),
    itemCount: json["itemCount"],
    paymentStatus: json["paymentStatus"],
    orderId: json["orderId"],
    buyer: Buyer.fromJson(json["buyer"]),
    deliveryStatus: json['deliveryStatus'],
    isAcceptance: json['isAcceptance'],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "customerName": customerName,
    "salesAmount": salesAmount,
    "timeStamp": timeStamp.toIso8601String(),
    "createdOn": createdOn.toIso8601String(),
    "itemCount": itemCount,
    "paymentStatus": paymentStatus,
    "deliveryStatus":deliveryStatus,
    "isAcceptance":isAcceptance,
    "orderId": orderId,
    "buyer": buyer.toJson(),
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
