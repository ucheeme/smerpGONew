// To parse this JSON data, do
//
//     final deliveryConfirmation = deliveryConfirmationFromJson(jsonString);

import 'dart:convert';

DeliveryConfirmation deliveryConfirmationFromJson(String str) => DeliveryConfirmation.fromJson(json.decode(str));

String deliveryConfirmationToJson(DeliveryConfirmation data) => json.encode(data.toJson());

class DeliveryConfirmation {
  String orderId;
  String merchantCode;
  String? code;

  DeliveryConfirmation({
    required this.orderId,
    required this.merchantCode,
     this.code,
  });

  factory DeliveryConfirmation.fromJson(Map<String, dynamic> json) => DeliveryConfirmation(
    orderId: json["orderId"],
    merchantCode: json["merchantCode"],
    code: json["code"],
  );

  Map<String, dynamic> toJson() => {
    "orderId": orderId,
    "merchantCode": merchantCode,
    "code": code,
  };
}
