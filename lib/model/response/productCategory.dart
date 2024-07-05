// To parse this JSON data, do
//
//     final productUnitCategory = productUnitCategoryFromJson(jsonString);

import 'dart:convert';

ProductUnitCategory productUnitCategoryFromJson(String str) => ProductUnitCategory.fromJson(json.decode(str));

String productUnitCategoryToJson(ProductUnitCategory data) => json.encode(data.toJson());

class ProductUnitCategory {
  bool isSuccess;
  String message;
  List<DefaultProductCategory> data;

  ProductUnitCategory({
    required this.isSuccess,
    required this.message,
    required this.data,
  });

  factory ProductUnitCategory.fromJson(Map<String, dynamic> json) =>
      ProductUnitCategory(
    isSuccess: json["isSuccess"],
    message: json["message"],
    data: List<DefaultProductCategory>.from(json["data"].map((x) =>
        DefaultProductCategory.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "isSuccess": isSuccess,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class DefaultProductCategory {
  int id;
  String name;
  String description;

  DefaultProductCategory({
    required this.id,
    required this.name,
    required this.description,
  });

  factory DefaultProductCategory.fromJson(Map<String, dynamic> json) => DefaultProductCategory(
    id: json["id"],
    name: json["name"],
    description: json["description"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "description": description,
  };
}
