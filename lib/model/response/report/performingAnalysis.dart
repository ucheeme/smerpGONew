// To parse this JSON data, do
//
//     final performingAnalysis = performingAnalysisFromJson(jsonString);

import 'dart:convert';

PerformingAnalysis performingAnalysisFromJson(String str) => PerformingAnalysis.fromJson(json.decode(str));

String performingAnalysisToJson(PerformingAnalysis data) => json.encode(data.toJson());

class PerformingAnalysis {
  List<ReportProduct> lastWeek;
  List<ReportProduct> thisWeek;
  List<ReportProduct> lastMonth;
  List<ReportProduct> thisMonth;

  PerformingAnalysis({
    required this.lastWeek,
    required this.thisWeek,
    required this.lastMonth,
    required this.thisMonth,
  });

  factory PerformingAnalysis.fromJson(Map<String, dynamic> json) => PerformingAnalysis(
    lastWeek: List<ReportProduct>.from(json["lastWeek"].map((x) => ReportProduct.fromJson(x))),
    thisWeek: List<ReportProduct>.from(json["thisWeek"].map((x) => ReportProduct.fromJson(x))),
    lastMonth: List<ReportProduct>.from(json["lastMonth"].map((x) => ReportProduct.fromJson(x))),
    thisMonth: List<ReportProduct>.from(json["thisMonth"].map((x) => ReportProduct.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "lastWeek": List<dynamic>.from(lastWeek.map((x) => x)),
    "thisWeek": List<dynamic>.from(thisWeek.map((x) => x.toJson())),
    "lastMonth": List<dynamic>.from(lastMonth.map((x) => x)),
    "thisMonth": List<dynamic>.from(thisMonth.map((x) => x.toJson())),
  };
}

class ReportProduct {
  int productId;
  String productName;
  int count;

  ReportProduct({
    required this.productId,
    required this.productName,
    required this.count,
  });

  factory ReportProduct.fromJson(Map<String, dynamic> json) => ReportProduct(
    productId: json["productId"],
    productName: json["productName"],
    count: json["count"],
  );

  Map<String, dynamic> toJson() => {
    "productId": productId,
    "productName": productName,
    "count": count,
  };
}
