// To parse this JSON data, do
//
//     final inventoryList = inventoryListFromJson(jsonString);

import 'dart:convert';

import 'package:get/get.dart';

InventoryList inventoryListFromJson(String str) => InventoryList.fromJson(json.decode(str));

String inventoryListToJson(InventoryList data) => json.encode(data.toJson());

class InventoryList {
  bool isSuccess;
  String message;
  List<InventoryInfo>? data;

  InventoryList({
    required this.isSuccess,
    required this.message,
    this.data,
  });

  factory InventoryList.fromJson(Map<String, dynamic> json) => InventoryList(
    isSuccess: json["isSuccess"],
    message: json["message"],
    data:  (json['data'] == null)?json['data']:
    List<InventoryInfo>.from(json["data"].map((x) => InventoryInfo.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "isSuccess": isSuccess,
    "message": message,
    "data": (data==null)?null:
    List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class InventoryInfo {
  int id;
  String productName;
  dynamic productImage;
  String productCategory;
  double purchasePrice;
  int quantity;
  double sellingPrice;
  String unitCategory;
  String createdBy;
  DateTime createdOn;
  String updatedBy;
  dynamic updatedOn;
  DateTime timeStamp;

  InventoryInfo({
    required this.id,
    required this.productName,
    this.productImage,
    required this.productCategory,
    required this.purchasePrice,
    required this.quantity,
    required this.sellingPrice,
    required this.unitCategory,
    required this.createdBy,
    required this.createdOn,
    required this.updatedBy,
    this.updatedOn,
    required this.timeStamp,
  });

  factory InventoryInfo.fromJson(Map<String, dynamic> json) => InventoryInfo(
    id: json["id"],
    productName: json["productName"],
    productImage: json["productImage"],
    productCategory: json["productCategory"],
    purchasePrice: json["purchasePrice"],
    quantity: json["quantity"],
    sellingPrice: json["sellingPrice"],
    unitCategory: json["unitCategory"],
    createdBy: json["createdBy"],
    createdOn: DateTime.parse(json["createdOn"]),
    updatedBy: json["updatedBy"],
    updatedOn: json["updatedOn"],
    timeStamp: DateTime.parse(json["timeStamp"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "productName": productName,
    "productImage": productImage,
    "productCategory": productCategory,
    "purchasePrice": purchasePrice,
    "quantity": quantity,
    "sellingPrice": sellingPrice,
    "unitCategory": unitCategory,
    "createdBy": createdBy,
    "createdOn": createdOn.toIso8601String(),
    "updatedBy": updatedBy,
    "updatedOn": updatedOn,
    "timeStamp": timeStamp.toIso8601String(),
  };
}