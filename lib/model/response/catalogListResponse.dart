// To parse this JSON data, do
//
//     final catalogListResponse = catalogListResponseFromJson(jsonString);

import 'dart:convert';

CatalogListResponse catalogListResponseFromJson(String str) => CatalogListResponse.fromJson(json.decode(str));

String catalogListResponseToJson(CatalogListResponse data) => json.encode(data.toJson());

class CatalogListResponse {
  bool isSuccess;
  String message;
  List<CatalogData> data;

  CatalogListResponse({
    required this.isSuccess,
    required this.message,
    required this.data,
  });

  factory CatalogListResponse.fromJson(Map<String, dynamic> json) => CatalogListResponse(
    isSuccess: json["isSuccess"],
    message: json["message"],
    data: List<CatalogData>.from(json["data"].map((x) => CatalogData.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "isSuccess": isSuccess,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class CatalogData {
  int id;
  dynamic productImage;
  String productName;
  String productCategory;
  String productUnitCategory;
  double sellingPrice;

  CatalogData({
    required this.id,
     this.productImage,
    required this.productName,
    required this.productCategory,
    required this.productUnitCategory,
    required this.sellingPrice,
  });

  factory CatalogData.fromJson(Map<String, dynamic> json) => CatalogData(
    id: json["id"],
    productImage: json["productImage"],
    productName: json["productName"],
    productCategory: json["productCategory"],
    productUnitCategory: json["productUnitCategory"],
    sellingPrice: json["sellingPrice"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "productImage": productImage,
    "productName": productName,
    "productCategory": productCategory,
    "productUnitCategory": productUnitCategory,
    "sellingPrice": sellingPrice,
  };
}
