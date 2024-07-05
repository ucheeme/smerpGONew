// To parse this JSON data, do
//
//     final yearSalesReport = yearSalesReportFromJson(jsonString);

import 'dart:convert';

YearSalesReport yearSalesReportFromJson(String str) => YearSalesReport.fromJson(json.decode(str));

String yearSalesReportToJson(YearSalesReport data) => json.encode(data.toJson());

class YearSalesReport {
  bool isSuccess;
  String message;
  Data data;

  YearSalesReport({
    required this.isSuccess,
    required this.message,
    required this.data,
  });

  factory YearSalesReport.fromJson(Map<String, dynamic> json) => YearSalesReport(
    isSuccess: json["isSuccess"],
    message: json["message"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "isSuccess": isSuccess,
    "message": message,
    "data": data.toJson(),
  };
}

class Data {
  List<Sale> sales;

  Data({
    required this.sales,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    sales: List<Sale>.from(json["sales"].map((x) => Sale.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "sales": List<dynamic>.from(sales.map((x) => x.toJson())),
  };
}

class Sale {
  int month;
  int count;
  int amount;

  Sale({
    required this.month,
    required this.count,
    required this.amount,
  });

  factory Sale.fromJson(Map<String, dynamic> json) => Sale(
    month: json["month"],
    count: json["count"],
    amount: json["amount"],
  );

  Map<String, dynamic> toJson() => {
    "month": month,
    "count": count,
    "amount": amount,
  };
}
