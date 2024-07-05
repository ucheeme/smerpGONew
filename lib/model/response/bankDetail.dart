// To parse this JSON data, do
//
//     final bankDetailReponse = bankDetailReponseFromJson(jsonString);

import 'dart:convert';

BankDetailReponse bankDetailReponseFromJson(String str) => BankDetailReponse.fromJson(json.decode(str));

String bankDetailReponseToJson(BankDetailReponse data) => json.encode(data.toJson());

class BankDetailReponse {
  String? bankName;
  String? accountName;
  String? accountNumber;

  BankDetailReponse({
     this.bankName,
     this.accountName,
     this.accountNumber,
  });

  factory BankDetailReponse.fromJson(Map<String, dynamic> json) => BankDetailReponse(
    bankName: json["bankName"],
    accountName: json["accountName"],
    accountNumber: json["accountNumber"],
  );

  Map<String, dynamic> toJson() => {
    "bankName": bankName,
    "accountName": accountName,
    "accountNumber": accountNumber,
  };
}
