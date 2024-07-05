// To parse this JSON data, do
//
//     final monthSalesReport = monthSalesReportFromJson(jsonString);

import 'dart:convert';

MonthSalesReport monthSalesReportFromJson(String str) => MonthSalesReport.fromJson(json.decode(str));

String monthSalesReportToJson(MonthSalesReport data) => json.encode(data.toJson());

class MonthSalesReport {
  bool isSuccess;
  String message;
  Data? data;

  MonthSalesReport({
    required this.isSuccess,
    required this.message,
    required this.data,
  });

  factory MonthSalesReport.fromJson(Map<String, dynamic> json) => MonthSalesReport(
    isSuccess: json["isSuccess"],
    message: json["message"],
    data:(json["data"]==null)?null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "isSuccess": isSuccess,
    "message": message,
    "data": (data?.toJson()==null)?null :data!.toJson(),
  };
}

class Data {
  List<SaleReportData> sales;

  Data({
    required this.sales,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    sales: List<SaleReportData>.from(json["sales"].map((x) => SaleReportData.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "sales": List<dynamic>.from(sales.map((x) => x.toJson())),
  };
}

class SaleReportData {
  int week;
  int count;
  dynamic amount;

  SaleReportData({
    required this.week,
    required this.count,
    required this.amount,
  });

  factory SaleReportData.fromJson(Map<String, dynamic> json) => SaleReportData(
    week: json["week"],
    count: json["count"],
    amount: json["amount"],
  );

  Map<String, dynamic> toJson() => {
    "week": week,
    "count": count,
    "amount": amount,
  };
}
