// To parse this JSON data, do
//
//     final saleListInfo = saleListInfoFromJson(jsonString);

import 'dart:convert';

SaleListInfo saleListInfoFromJson(String str) => SaleListInfo.fromJson(json.decode(str));

String saleListInfoToJson(SaleListInfo data) => json.encode(data.toJson());

class SaleListInfo {
  bool isSuccess;
  String message;
  List<SaleListDataInfo> data;

  SaleListInfo({
    required this.isSuccess,
    required this.message,
    required this.data,
  });

  factory SaleListInfo.fromJson(Map<String, dynamic> json) => SaleListInfo(
    isSuccess: json["isSuccess"],
    message: json["message"],
    data: List<SaleListDataInfo>.from(json["data"].map((x) => SaleListDataInfo.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "isSuccess": isSuccess,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class SaleListDataInfo {
  int salesId;
  String customerName;
  List<SalesItemInfo> saleProducts;

  SaleListDataInfo({
    required this.salesId,
    required this.customerName,
    required this.saleProducts,
  });

  factory SaleListDataInfo.fromJson(Map<String, dynamic> json) => SaleListDataInfo(
    salesId: json["salesId"],
    customerName: json["customerName"],
    saleProducts: List<SalesItemInfo>.from(json["items"].map((x) => SalesItemInfo.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "salesId": salesId,
    "customerName": customerName,
    "items": List<dynamic>.from(saleProducts.map((x) => x.toJson())),
  };
}

class SalesItemInfo {
  int salesItemId;
  int productId;
  dynamic productImage;
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

  SalesItemInfo({
    required this.salesItemId,
    required this.productId,
    required this.productImage,
    required this.productName,
    required this.productCategory,
    required this.productUnitCategory,
    required this.quantity,
    required this.paymentStatus,
    required this.purchasePrice,
    required this.sellingPrice,
    required this.salesAmount,
    required this.timeStamp,
    required this.createdOn,
  });

  factory SalesItemInfo.fromJson(Map<String, dynamic> json) => SalesItemInfo(
    salesItemId: json["salesItemId"],
    productId: json["productId"],
    productImage: json["productImage"],
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
    "salesItemId": salesItemId,
    "productId": productId,
    "productImage": productImage,
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
