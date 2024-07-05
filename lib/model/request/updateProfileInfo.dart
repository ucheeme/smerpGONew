// To parse this JSON data, do
//
//     final profileInfoUpdate = profileInfoUpdateFromJson(jsonString);

import 'dart:convert';

ProfileInfoUpdate profileInfoUpdateFromJson(String str) => ProfileInfoUpdate.fromJson(json.decode(str));

String profileInfoUpdateToJson(ProfileInfoUpdate data) => json.encode(data.toJson());

class ProfileInfoUpdate {
  String actionBy;
  DateTime actionOn;
  String firstName;
  String otherName;
  String businessName;

  ProfileInfoUpdate({
    required this.actionBy,
    required this.actionOn,
    required this.firstName,
    required this.otherName,
    required this.businessName,
  });

  factory ProfileInfoUpdate.fromJson(Map<String, dynamic> json) => ProfileInfoUpdate(
    actionBy: json["actionBy"],
    actionOn: DateTime.parse(json["actionOn"]),
    firstName: json["firstName"],
    otherName: json["otherName"],
    businessName: json["businessName"],
  );

  Map<String, dynamic> toJson() => {
    "actionBy": actionBy,
    "actionOn": actionOn.toIso8601String(),
    "firstName": firstName,
    "otherName": otherName,
    "businessName": businessName,
  };
}
