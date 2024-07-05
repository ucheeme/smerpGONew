// To parse this JSON data, do
//
//     final inventoryCount = inventoryCountFromJson(jsonString);

import 'dart:convert';

InventoryCount inventoryCountFromJson(String str) => InventoryCount.fromJson(json.decode(str));

String inventoryCountToJson(InventoryCount data) => json.encode(data.toJson());

class InventoryCount {
  bool isSuccess;
  String message;
  InventoryCountData data;

  InventoryCount({
    required this.isSuccess,
    required this.message,
    required this.data,
  });

  factory InventoryCount.fromJson(Map<String, dynamic> json) => InventoryCount(
    isSuccess: json["isSuccess"],
    message: json["message"],
    data: InventoryCountData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "isSuccess": isSuccess,
    "message": message,
    "data": data.toJson(),
  };
}

class InventoryCountData {
  int productCount;
  double purchaseValue;
  double salesValue;

  InventoryCountData({
    required this.productCount,
    required this.purchaseValue,
    required this.salesValue,
  });

  factory InventoryCountData.fromJson(Map<String, dynamic> json) => InventoryCountData(
    productCount: json["productCount"],
    purchaseValue: json["purchaseValue"],
    salesValue: json["salesValue"],
  );

  Map<String, dynamic> toJson() => {
    "productCount": productCount,
    "purchaseValue": purchaseValue,
    "salesValue": salesValue,
  };
}
