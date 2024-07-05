// To parse this JSON data, do
//
//     final customSalesAnalysis = customSalesAnalysisFromJson(jsonString);

import 'dart:convert';

CustomSalesAnalysis customSalesAnalysisFromJson(String str) => CustomSalesAnalysis.fromJson(json.decode(str));

String customSalesAnalysisToJson(CustomSalesAnalysis data) => json.encode(data.toJson());

class CustomSalesAnalysis {
  double sales;
  double order;
  double offline;

  CustomSalesAnalysis({
    required this.sales,
    required this.order,
    required this.offline,
  });

  factory CustomSalesAnalysis.fromJson(Map<String, dynamic> json) => CustomSalesAnalysis(
    sales: json["sales"],
    order: json["orders"],
    offline: json["offlineSales"],
  );

  Map<String, dynamic> toJson() => {
    "sales": sales,
    "orders": order,
    "offlineSales": offline,
  };
}
