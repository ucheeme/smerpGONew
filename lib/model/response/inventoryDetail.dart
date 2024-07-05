// To parse this JSON data, do
//
//     final inventoryDetail = inventoryDetailFromJson(jsonString);

import 'dart:convert';

InventoryDetail inventoryDetailFromJson(String str) => InventoryDetail.fromJson(json.decode(str));

String inventoryDetailToJson(InventoryDetail data) => json.encode(data.toJson());

class InventoryDetail {
  bool isSuccess;
  String message;
  InventoryInformation data;

  InventoryDetail({
    required this.isSuccess,
    required this.message,
    required this.data,
  });

  factory InventoryDetail.fromJson(Map<String, dynamic> json) => InventoryDetail(
    isSuccess: json["isSuccess"],
    message: json["message"],
    data: InventoryInformation.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "isSuccess": isSuccess,
    "message": message,
    "data": data.toJson(),
  };
}

class InventoryInformation {
  int id;
  String productName;
  String productImage;
  String productCategory;
  double purchasePrice;
  int quantity;
  double sellingPrice;
  int? units;
  String unitCategory;
  String createdBy;
  DateTime createdOn;
  String updatedBy;
  dynamic updatedOn;
  DateTime timeStamp;

  InventoryInformation({
    required this.id,
    required this.productName,
    required this.productImage,
    required this.productCategory,
    required this.purchasePrice,
    required this.quantity,
    required this.sellingPrice,
    this.units,
    required this.unitCategory,
    required this.createdBy,
    required this.createdOn,
    required this.updatedBy,
    this.updatedOn,
    required this.timeStamp,
  });

  factory InventoryInformation.fromJson(Map<String, dynamic> json) => InventoryInformation(
    id: json["id"],
    productName: json["productName"],
    productImage: json["productImage"],
    productCategory: json["productCategory"],
    purchasePrice: json["purchasePrice"],
    quantity: json["quantity"],
    sellingPrice: json["sellingPrice"],
    units: json["units"],
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
    "units": units,
    "unitCategory": unitCategory,
    "createdBy": createdBy,
    "createdOn": createdOn.toIso8601String(),
    "updatedBy": updatedBy,
    "updatedOn": updatedOn,
    "timeStamp": timeStamp.toIso8601String(),
  };
}
