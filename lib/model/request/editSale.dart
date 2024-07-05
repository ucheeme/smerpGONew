// To parse this JSON data, do
//
//     final editSaleBody = editSaleBodyFromJson(jsonString);

import 'dart:convert';

EditSaleBody editSaleBodyFromJson(String str) => EditSaleBody.fromJson(json.decode(str));

String editSaleBodyToJson(EditSaleBody data) => json.encode(data.toJson());

class EditSaleBody {
  String actionBy;
  DateTime actionOn;
  int productId;
  int quantity;
  int paymentStatus;
  DateTime timeStamp;

  EditSaleBody({
    required this.actionBy,
    required this.actionOn,
    required this.productId,
    required this.quantity,
    required this.paymentStatus,
    required this.timeStamp,
  });

  factory EditSaleBody.fromJson(Map<String, dynamic> json) => EditSaleBody(
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
