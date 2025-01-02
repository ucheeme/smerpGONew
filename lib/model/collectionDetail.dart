// To parse this JSON data, do
//
//     final collectionDetail = collectionDetailFromJson(jsonString);

import 'dart:convert';

CollectionDetail collectionDetailFromJson(String str) => CollectionDetail.fromJson(json.decode(str));

String collectionDetailToJson(CollectionDetail data) => json.encode(data.toJson());

class CollectionDetail {
  String collectionName;
  List<Product> products;

  CollectionDetail({
    required this.collectionName,
    required this.products,
  });

  factory CollectionDetail.fromJson(Map<String, dynamic> json) => CollectionDetail(
    collectionName: json["collectionName"],
    products: List<Product>.from(json["products"].map((x) => Product.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "collectionName": collectionName,
    "products": List<dynamic>.from(products.map((x) => x.toJson())),
  };
}

class Product {
  int id;
  String productImage;
  String productName;
  String productCategory;
  String productUnitCategory;
  int quantity;
  double sellingPrice;

  Product({
    required this.id,
    required this.productImage,
    required this.productName,
    required this.productCategory,
    required this.productUnitCategory,
    required this.quantity,
    required this.sellingPrice,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    id: json["id"],
    productImage: json["productImage"]??"",
    productName: json["productName"],
    productCategory: json["productCategory"],
    productUnitCategory: json["productUnitCategory"],
    quantity: json["quantity"],
    sellingPrice: json["sellingPrice"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "productImage": productImage,
    "productName": productName,
    "productCategory": productCategory,
    "productUnitCategory": productUnitCategory,
    "quantity": quantity,
    "sellingPrice": sellingPrice,
  };
}
