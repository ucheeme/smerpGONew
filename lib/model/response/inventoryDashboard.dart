// To parse this JSON data, do
//
//     final inventoryDashboard = inventoryDashboardFromJson(jsonString);

import 'dart:convert';

InventoryDashboard inventoryDashboardFromJson(String str) => InventoryDashboard.fromJson(json.decode(str));

String inventoryDashboardToJson(InventoryDashboard data) => json.encode(data.toJson());

class InventoryDashboard {
  bool isSuccess;
  String message;
  Data data;

  InventoryDashboard({
    required this.isSuccess,
    required this.message,
    required this.data,
  });

  factory InventoryDashboard.fromJson(Map<String, dynamic> json) => InventoryDashboard(
    isSuccess: json["isSuccess"],
    message: json["message"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "isSuccess": isSuccess,
    "message": message,
    "data": data.toJson(),
  };
}

class Data {
  int productCount;
  double purchaseValue;
  double salesValue;

  Data({
    required this.productCount,
    required this.purchaseValue,
    required this.salesValue,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
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
