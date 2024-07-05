// To parse this JSON data, do
//
//     final validateOtpSent = validateOtpSentFromJson(jsonString);

import 'dart:convert';

ValidateOtpSent validateOtpSentFromJson(String str) => ValidateOtpSent.fromJson(json.decode(str));

String validateOtpSentToJson(ValidateOtpSent data) => json.encode(data.toJson());

class ValidateOtpSent {
  int otpSource;
  String source;
  String otp;

  ValidateOtpSent({
    required this.otpSource,
    required this.source,
    required this.otp,
  });

  factory ValidateOtpSent.fromJson(Map<String, dynamic> json) => ValidateOtpSent(
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
