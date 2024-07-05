// To parse this JSON data, do
//
//     final salesList = salesListFromJson(jsonString);

import 'dart:convert';

SalesListONE salesListFromJson(String str) => SalesListONE.fromJson(json.decode(str));

String salesListToJson(SalesListONE data) => json.encode(data.toJson());

class SalesListONE {
  bool isSuccess;
  String message;
  List<SaleData>? data;

  SalesListONE({
    required this.isSuccess,
    required this.message,
    this.data,
  });

  factory SalesListONE.fromJson(Map<String, dynamic> json) => SalesListONE(
    isSuccess: json["isSuccess"],
    message: json["message"],
    data: (json['data'] == null)?json['data']:
    List<SaleData>.from(json["data"].map((x) => SaleData.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "isSuccess": isSuccess,
    "message": message,
    "data":(data == null)?null:
    List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class SaleData {
  int id;
  int productId;
  String productName;
  String productCategory;
  String productUnitCategory;
  int quantity;
  String paymentStatus;
  double purchasePrice;
  double sellingPrice;
  double salesAmount;
  DateTime timeStamp;
  DateTime createdOn;

  SaleData({
    required this.id,
    required this.productId,
    required this.productName,
    required this.productCategory,
    required this.productUnitCategory,
    required this.quantity,
    required this.paymentStatus,
    required this.sellingPrice,
    required this.purchasePrice,
    required this.salesAmount,
    required this.timeStamp,
    required this.createdOn,
  });

  factory SaleData.fromJson(Map<String, dynamic> json) => SaleData(
    id: json["id"],
    productId: json["productId"],
    productName: json["productName"],
    productCategory: json["productCategory"],
    productUnitCategory: json["productUnitCategory"],
    quantity: json["quantity"],
    paymentStatus: json["paymentStatus"],
    purchasePrice: json["purchasePrice"],
    sellingPrice: json["sellingPrice"],
    salesAmount: json["salesAmount"],
    timeStamp: DateTime.parse(json["timeStamp"]),
    createdOn: DateTime.parse(json["createdOn"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "productId": productId,
    "productName": productName,
    "productCategory": productCategory,
    "productUnitCategory": productUnitCategory,
    "quantity": quantity,
    "paymentStatus": paymentStatus,
    "purchasePrice": purchasePrice,
    "sellingPrice": sellingPrice,
    "salesAmount": salesAmount,
    "timeStamp": timeStamp.toIso8601String(),
    "createdOn": createdOn.toIso8601String(),
  };
}
