// To parse this JSON data, do
//
//     final signUpToken = signUpTokenFromJson(jsonString);

import 'dart:convert';

SignUpToken signUpTokenFromJson(String str) => SignUpToken.fromJson(json.decode(str));

String signUpTokenToJson(SignUpToken data) => json.encode(data.toJson());

class SignUpToken {
  int identitySource;
  String identity;

  SignUpToken({
    required this.identitySource,
    required this.identity,
  });

  factory SignUpToken.fromJson(Map<String, dynamic> json) => SignUpToken(
    identitySource: json["identitySource"],
    identity: json["identity"],
  );

  Map<String, dynamic> toJson() => {
    "identitySource": identitySource,
    "identity": identity,
  };
}