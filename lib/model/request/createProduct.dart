// To parse this JSON data, do
//
//     final createProduct = createProductFromJson(jsonString);

import 'dart:convert';

CreateProduct createProductFromJson(String str) => CreateProduct.fromJson(json.decode(str));

String createProductToJson(CreateProduct data) => json.encode(data.toJson());

class CreateProduct {
  String actionBy;
  DateTime actionOn;
  String productName;
  String productImage;
  int productCategoryId;
  double purchasePrice;
  double sellingPrice;
  int quantity;
  //int units;
  int unitCategoryId;
  DateTime timeStamp;

  CreateProduct({
    required this.actionBy,
    required this.actionOn,
    required this.productName,
    required this.productImage,
    required this.productCategoryId,
    required this.purchasePrice,
    required this.sellingPrice,
    required this.quantity,
    //required this.units,
    required this.unitCategoryId,
    required this.timeStamp,
  });

  factory CreateProduct.fromJson(Map<String, dynamic> json) => CreateProduct(
    actionBy: json["actionBy"],
    actionOn: DateTime.parse(json["actionOn"]),
    productName: json["productName"],
    productImage: json["productImage"],
    productCategoryId: json["productCategoryId"],
    purchasePrice: json["purchasePrice"],
    sellingPrice: json["sellingPrice"],
    quantity: json["quantity"],
   // units: json["units"],
    unitCategoryId: json["unitCategoryId"],
    timeStamp: DateTime.parse(json["timeStamp"]),
  );

  Map<String, dynamic> toJson() => {
    "actionBy": actionBy,
    "actionOn": actionOn.toIso8601String(),
    "productName": productName,
    "productImage": productImage,
    "productCategoryId": productCategoryId,
    "purchasePrice": purchasePrice,
    "sellingPrice": sellingPrice,
    "quantity": quantity,
    //"units": units,
    "unitCategoryId": unitCategoryId,
    "timeStamp": timeStamp.toIso8601String(),
  };
}
