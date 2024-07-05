// To parse this JSON data, do
//
//     final storeBankDetail = storeBankDetailFromJson(jsonString);

import 'dart:convert';

StoreBankDetail storeBankDetailFromJson(String str) => StoreBankDetail.fromJson(json.decode(str));

String storeBankDetailToJson(StoreBankDetail data) => json.encode(data.toJson());

class StoreBankDetail {
  String actionBy;
  DateTime actionOn;
  String bankName;
  String accountNo;
  String accountName;

  StoreBankDetail({
    required this.actionBy,
    required this.actionOn,
    required this.bankName,
    required this.accountNo,
    required this.accountName,
  });

  factory StoreBankDetail.fromJson(Map<String, dynamic> json) => StoreBankDetail(
    actionBy: json["actionBy"],
    actionOn: DateTime.parse(json["actionOn"]),
    bankName: json["bankName"],
    accountNo: json["accountNo"],
    accountName: json["accountName"],
  );

  Map<String, dynamic> toJson() => {
    "actionBy": actionBy,
    "actionOn": actionOn.toIso8601String(),
    "bankName": bankName,
    "accountNo": accountNo,
    "accountName": accountName,
  };
}
