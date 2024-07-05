// To parse this JSON data, do
//
//     final signUpPin = signUpPinFromJson(jsonString);

import 'dart:convert';

SignUpPin signUpPinFromJson(String str) => SignUpPin.fromJson(json.decode(str));

String signUpPinToJson(SignUpPin data) => json.encode(data.toJson());

class SignUpPin {
  int otpSource;
  String source;
  String otp;
  String newPin;

  SignUpPin({
    required this.otpSource,
    required this.source,
    required this.otp,
    required this.newPin,
  });

  factory SignUpPin.fromJson(Map<String, dynamic> json) => SignUpPin(
    otpSource: json["otpSource"],
    source: json["source"],
    otp: json["otp"],
    newPin: json["newPIN"],
  );

  Map<String, dynamic> toJson() => {
    "otpSource": otpSource,
    "source": source,
    "otp": otp,
    "newPIN": newPin,
  };
}
