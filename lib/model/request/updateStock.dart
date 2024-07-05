// To parse this JSON data, do
//
//     final updateStockRequestBody = updateStockRequestBodyFromJson(jsonString);

import 'dart:convert';

UpdateStockRequestBody updateStockRequestBodyFromJson(String str) => UpdateStockRequestBody.fromJson(json.decode(str));

String updateStockRequestBodyToJson(UpdateStockRequestBody data) => json.encode(data.toJson());

class UpdateStockRequestBody {
  String actionBy;
  DateTime actionOn;
  int productId;
  int quantity;

  UpdateStockRequestBody({
    required this.actionBy,
    required this.actionOn,
    required this.productId,
    required this.quantity,
  });

  factory UpdateStockRequestBody.fromJson(Map<String, dynamic> json) => UpdateStockRequestBody(
    actionBy: json["actionBy"],
    actionOn: DateTime.parse(json["actionOn"]),
    productId: json["productId"],
    quantity: json["quantity"],
  );

  Map<String, dynamic> toJson() => {
    "actionBy": actionBy,
    "actionOn": actionOn.toIso8601String(),
    "productId": productId,
    "quantity": quantity,
  };
}
