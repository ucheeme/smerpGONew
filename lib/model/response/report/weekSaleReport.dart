// To parse this JSON data, do
//
//     final reportSalesByWeek = reportSalesByWeekFromJson(jsonString);

import 'dart:convert';

ReportSalesByWeek reportSalesByWeekFromJson(String str) => ReportSalesByWeek.fromJson(json.decode(str));

String reportSalesByWeekToJson(ReportSalesByWeek data) => json.encode(data.toJson());

class ReportSalesByWeek {
  bool isSuccess;
  String message;
  List<SaleReportDataWeek> data;

  ReportSalesByWeek({
    required this.isSuccess,
    required this.message,
    required this.data,
  });

  factory ReportSalesByWeek.fromJson(Map<String, dynamic> json) => ReportSalesByWeek(
    isSuccess: json["isSuccess"],
    message: json["message"],
    data: List<SaleReportDataWeek>.from(json["data"].map((x) => SaleReportDataWeek.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "isSuccess": isSuccess,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class SaleReportDataWeek {
  DateTime day;
  int count;
  dynamic amount;

  SaleReportDataWeek({
    required this.day,
    required this.count,
    required this.amount,
  });

  factory SaleReportDataWeek.fromJson(Map<String, dynamic> json) => SaleReportDataWeek(
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
