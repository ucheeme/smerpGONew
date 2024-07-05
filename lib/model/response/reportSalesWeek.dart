// To parse this JSON data, do
//
//     final reportSalesByWeek = reportSalesByWeekFromJson(jsonString);

import 'dart:convert';

ReportSalesByWeek reportSalesByWeekFromJson(String str) => ReportSalesByWeek.fromJson(json.decode(str));

String reportSalesByWeekToJson(ReportSalesByWeek data) => json.encode(data.toJson());

class ReportSalesByWeek {
  bool isSuccess;
  String message;
  List<SaleReortWeek> data;

  ReportSalesByWeek({
    required this.isSuccess,
    required this.message,
    required this.data,
  });

  factory ReportSalesByWeek.fromJson(Map<String, dynamic> json) => ReportSalesByWeek(
    isSuccess: json["isSuccess"],
    message: json["message"],
    data: List<SaleReortWeek>.from(json["data"].map((x) => SaleReortWeek.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "isSuccess": isSuccess,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class SaleReortWeek {
  DateTime day;
  int count;
  int amount;

  SaleReortWeek({
    required this.day,
    required this.count,
    required this.amount,
  });

  factory SaleReortWeek.fromJson(Map<String, dynamic> json) => SaleReortWeek(
    day: DateTime.parse(json["day"]),
    count: json["count"],
    amount: json["amount"],
  );

  Map<String, dynamic> toJson() => {
    "day": day.toIso8601String(),
    "count": count,
    "amount": amount,
  };
}
