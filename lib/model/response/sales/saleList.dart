// To parse this JSON data, do
//
//     final saleList = saleListFromJson(jsonString);

import 'dart:convert';

SaleList saleListFromJson(String str) => SaleList.fromJson(json.decode(str));

String saleListToJson(SaleList data) => json.encode(data.toJson());

class SaleList {
  bool isSuccess;
  String message;
  List<SalesDatum>? data;

  SaleList({
    required this.isSuccess,
    required this.message,
    this.data,
  });

  factory SaleList.fromJson(Map<String, dynamic> json) => SaleList(
    isSuccess: json["isSuccess"],
    message: json["message"],
    data: (json["data"]==null)?null:List<SalesDatum>.from(json["data"].map((x) => SalesDatum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "isSuccess": isSuccess,
    "message": message,
    "data":(data==null)?null: List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class SalesDatum {
  int id;
  String customerName;
  double salesAmount;
  DateTime timeStamp;
  DateTime createdOn;
  int itemCount;
  String paymentStatus;
  SalesDatum({
    required this.id,
    required this.customerName,
    required this.salesAmount,
    required this.timeStamp,
    required this.createdOn,
    required this.itemCount,
    required this.paymentStatus
  });

  factory SalesDatum.fromJson(Map<String, dynamic> json) => SalesDatum(
    id: json["id"],
    customerName: json["customerName"],
    salesAmount: json["salesAmount"],
    timeStamp: DateTime.parse(json["timeStamp"]),
    createdOn: DateTime.parse(json["createdOn"]),
    itemCount: json["itemCount"],
    paymentStatus: json["paymentStatus"]
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "customerName": customerName,
    "salesAmount": salesAmount,
    "timeStamp": timeStamp.toIso8601String(),
    "createdOn": createdOn.toIso8601String(),
    "itemCount": itemCount,
    "paymentStatus":paymentStatus
  };
}
