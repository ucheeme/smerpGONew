// To parse this JSON data, do
//
//     final signInResponse = signInResponseFromJson(jsonString);

import 'dart:convert';

SignInResponse signInResponseFromJson(String str) => SignInResponse.fromJson(json.decode(str));

String signInResponseToJson(SignInResponse data) => json.encode(data.toJson());

class SignInResponse {
  bool isSuccess;
  String message;
  Data data;

  SignInResponse({
    required this.isSuccess,
    required this.message,
    required this.data,
  });

  factory SignInResponse.fromJson(Map<String, dynamic> json) => SignInResponse(
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
  String firstname;
  String lastName;
  DateTime lastLogin;
  String? avatar;
  Data({
    required this.firstname,
    required this.lastName,
    required this.lastLogin,
    this.avatar
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    firstname: json["firstName"],
    lastName: json["lastName"],
    lastLogin: DateTime.parse(json["lastLogin"]),
    avatar: json["avatar"]
  );

  Map<String, dynamic> toJson() => {
    "firstName": firstname,
    "lastName": lastName,
    "lastLogin": lastLogin.toIso8601String(),
    "avatar":avatar
  };
}
