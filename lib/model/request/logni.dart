// To parse this JSON data, do
//
//     final login = loginFromJson(jsonString);

import 'dart:convert';

Login loginFromJson(String str) => Login.fromJson(json.decode(str));

String loginToJson(Login data) => json.encode(data.toJson());

class Login {
  String username;
  String pin;

  Login({
    required this.username,
    required this.pin,
  });

  factory Login.fromJson(Map<String, dynamic> json) => Login(
    username: json["username"],
    pin: json["pin"],
  );

  Map<String, dynamic> toJson() => {
    "username": username,
    "pin": pin,
  };
}
