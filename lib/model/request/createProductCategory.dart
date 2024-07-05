// To parse this JSON data, do
//
//     final createProductCategory = createProductCategoryFromJson(jsonString);

import 'dart:convert';

CreateProductCategory createProductCategoryFromJson(String str) => CreateProductCategory.fromJson(json.decode(str));

String createProductCategoryToJson(CreateProductCategory data) => json.encode(data.toJson());

class CreateProductCategory {
  String actionBy;
  DateTime actionOn;
  String name;
  String description;

  CreateProductCategory({
    required this.actionBy,
    required this.actionOn,
    required this.name,
    required this.description,
  });

  factory CreateProductCategory.fromJson(Map<String, dynamic> json) => CreateProductCategory(
    actionBy: json["actionBy"],
    actionOn: DateTime.parse(json["actionOn"]),
    name: json["name"],
    description: json["description"],
  );

  Map<String, dynamic> toJson() => {
    "actionBy": actionBy,
    "actionOn": actionOn.toIso8601String(),
    "name": name,
    "description": description,
  };
}