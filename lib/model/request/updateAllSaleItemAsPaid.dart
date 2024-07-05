// To parse this JSON data, do
//
//     final updateAllSaleItemAsPaid = updateAllSaleItemAsPaidFromJson(jsonString);

import 'dart:convert';

List<UpdateAllSaleItemAsPaid> updateAllSaleItemAsPaidFromJson(String str) => List<UpdateAllSaleItemAsPaid>.from(json.decode(str).map((x) => UpdateAllSaleItemAsPaid.fromJson(x)));

String updateAllSaleItemAsPaidToJson(List<UpdateAllSaleItemAsPaid> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class UpdateAllSaleItemAsPaid {
  String actionBy;
  DateTime actionOn;
  int itemId;
  int productId;
  int quantity;
  int paymentStatus;
  DateTime timeStamp;

  UpdateAllSaleItemAsPaid({
    required this.actionBy,
    required this.actionOn,
    required this.itemId,
    required this.productId,
    required this.quantity,
    required this.paymentStatus,
    required this.timeStamp,
  });

  factory UpdateAllSaleItemAsPaid.fromJson(Map<String, dynamic> json) => UpdateAllSaleItemAsPaid(
    actionBy: json["actionBy"],
    actionOn: DateTime.parse(json["actionOn"]),
    itemId: json["itemId"],
    productId: json["productId"],
    quantity: json["quantity"],
    paymentStatus: json["paymentStatus"],
    timeStamp: DateTime.parse(json["timeStamp"]),
  );

  Map<String, dynamic> toJson() => {
    "actionBy": actionBy,
    "actionOn": actionOn.toIso8601String(),
    "itemId": itemId,
    "productId": productId,
    "quantity": quantity,
    "paymentStatus": paymentStatus,
    "timeStamp": timeStamp.toIso8601String(),
  };
}
