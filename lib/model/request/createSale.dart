// To parse this JSON data, do
//
//     final createSale = createSaleFromJson(jsonString);

import 'dart:convert';

CreateSale createSaleFromJson(String str) => CreateSale.fromJson(json.decode(str));

String createSaleToJson(CreateSale data) => json.encode(data.toJson());

class CreateSale {
  String actionBy;
  DateTime actionOn;
  String customerName;
  List<SaleMoreInfo> sales;

  CreateSale({
    required this.actionBy,
    required this.actionOn,
    required this.customerName,
    required this.sales,
  });

  factory CreateSale.fromJson(Map<String, dynamic> json) => CreateSale(
    actionBy: json["actionBy"],
    actionOn: DateTime.parse(json["actionOn"]),
    customerName: json["customerName"],
    sales: List<SaleMoreInfo>.from(json["sales"].map((x) => SaleMoreInfo.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "actionBy": actionBy,
    "actionOn": actionOn.toIso8601String(),
    "customerName": customerName,
    "sales": List<dynamic>.from(sales.map((x) => x.toJson())),
  };
}

class SaleMoreInfo {
  String actionBy;
  DateTime actionOn;
  int productId;
  int quantity;
  int paymentStatus;
  DateTime timeStamp;

  SaleMoreInfo({
    required this.actionBy,
    required this.actionOn,
    required this.productId,
    required this.quantity,
    required this.paymentStatus,
    required this.timeStamp,
  });

  factory SaleMoreInfo.fromJson(Map<String, dynamic> json) => SaleMoreInfo(
    actionBy: json["actionBy"],
    actionOn: DateTime.parse(json["actionOn"]),
    productId: json["productId"],
    quantity: json["quantity"],
    paymentStatus: json["paymentStatus"],
    timeStamp: DateTime.parse(json["timeStamp"]),
  );

  Map<String, dynamic> toJson() => {
    "actionBy": actionBy,
    "actionOn": actionOn.toIso8601String(),
    "productId": productId,
    "quantity": quantity,
    "paymentStatus": paymentStatus,
    "timeStamp": timeStamp.toIso8601String(),
  };
}
