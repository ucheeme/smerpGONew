// To parse this JSON data, do
//
//     final userProfileInfo = userProfileInfoFromJson(jsonString);

import 'dart:convert';

UserProfileInfo userProfileInfoFromJson(String str) => UserProfileInfo.fromJson(json.decode(str));

String userProfileInfoToJson(UserProfileInfo data) => json.encode(data.toJson());

class UserProfileInfo {
  bool isSuccess;
  String message;
  Data data;

  UserProfileInfo({
    required this.isSuccess,
    required this.message,
    required this.data,
  });

  factory UserProfileInfo.fromJson(Map<String, dynamic> json) => UserProfileInfo(
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
  String avatar;
  String linkCode;
  String firstName;
  String lastName;
  String businessName;

  Data({
    required this.avatar,
    required this.linkCode,
    required this.firstName,
    required this.lastName,
    required this.businessName,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    avatar: json["avatar"],
    linkCode: json["linkCode"],
    firstName: json["firstName"],
    lastName: json["lastName"],
    businessName: json["businessName"],
  );

  Map<String, dynamic> toJson() => {
    "avatar": avatar,
    "linkCode": linkCode,
    "firstName": firstName,
    "lastName": lastName,
    "businessName": businessName,
  };
}
