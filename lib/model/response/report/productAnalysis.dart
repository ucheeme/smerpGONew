// To parse this JSON data, do
//
//     final productAnalysis = productAnalysisFromJson(jsonString);

import 'dart:convert';

ProductAnalysis productAnalysisFromJson(String str) => ProductAnalysis.fromJson(json.decode(str));

String productAnalysisToJson(ProductAnalysis data) => json.encode(data.toJson());

class ProductAnalysis {
  int sold;
  int stock;

  ProductAnalysis({
    required this.sold,
    required this.stock,
  });

  factory ProductAnalysis.fromJson(Map<String, dynamic> json) => ProductAnalysis(
    sold: json["sold"],
    stock: json["stock"],
  );

  Map<String, dynamic> toJson() => {
    "sold": sold,
    "stock": stock,
  };
}
