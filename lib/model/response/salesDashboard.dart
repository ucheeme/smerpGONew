// To parse this JSON data, do
//
//     final salesDashboard = salesDashboardFromJson(jsonString);

import 'dart:convert';

SalesDashboard salesDashboardFromJson(String str) => SalesDashboard.fromJson(json.decode(str));

String salesDashboardToJson(SalesDashboard data) => json.encode(data.toJson());

class SalesDashboard {
  bool isSuccess;
  String message;
  Data data;

  SalesDashboard({
    required this.isSuccess,
    required this.message,
    required this.data,
  });

  factory SalesDashboard.fromJson(Map<String, dynamic> json) => SalesDashboard(
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
  int salasCount;
  int salasCountCurrentMonth;
  double salasAmount;
  double salasAmountCurrentMonth;

  Data({
    required this.salasCount,
    required this.salasCountCurrentMonth,
    required this.salasAmount,
    required this.salasAmountCurrentMonth,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    salasCount: json["salasCount"],
    salasCountCurrentMonth: json["salasCountCurrentMonth"],
    salasAmount: json["salasAmount"],
    salasAmountCurrentMonth: json["salasAmountCurrentMonth"],
  );

  Map<String, dynamic> toJson() => {
    "salasCount": salasCount,
    "salasCountCurrentMonth": salasCountCurrentMonth,
    "salasAmount": salasAmount,
    "salasAmountCurrentMonth": salasAmountCurrentMonth,
  };
}
