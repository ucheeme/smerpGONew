// To parse this JSON data, do
//
//     final signUpTokenValidation = signUpTokenValidationFromJson(jsonString);

import 'dart:convert';

SignUpTokenValidation signUpTokenValidationFromJson(String str) => SignUpTokenValidation.fromJson(json.decode(str));

String signUpTokenValidationToJson(SignUpTokenValidation data) => json.encode(data.toJson());

class SignUpTokenValidation {
  int otpSource;
  String source;
  String otp;

  SignUpTokenValidation({
    required this.otpSource,
    required this.source,
    required this.otp,
  });

  factory SignUpTokenValidation.fromJson(Map<String, dynamic> json) => SignUpTokenValidation(
    otpSource: json["otpSource"],
    source: json["source"],
    otp: json["otp"],
  );

  Map<String, dynamic> toJson() => {
    "otpSource": otpSource,
    "source": source,
    "otp": otp,
  };
}
