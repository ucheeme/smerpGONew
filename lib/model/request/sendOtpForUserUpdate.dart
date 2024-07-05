// To parse this JSON data, do
//
//     final sendOtpToVerifyUser = sendOtpToVerifyUserFromJson(jsonString);

import 'dart:convert';

SendOtpToVerifyUser sendOtpToVerifyUserFromJson(String str) => SendOtpToVerifyUser.fromJson(json.decode(str));

String sendOtpToVerifyUserToJson(SendOtpToVerifyUser data) => json.encode(data.toJson());

class SendOtpToVerifyUser {
  int identitySource;
  String identity;
  String systemIp;

  SendOtpToVerifyUser({
    required this.identitySource,
    required this.identity,
    required this.systemIp,
  });

  factory SendOtpToVerifyUser.fromJson(Map<String, dynamic> json) => SendOtpToVerifyUser(
    identitySource: json["identitySource"],
    identity: json["identity"],
    systemIp: json["systemIP"],
  );

  Map<String, dynamic> toJson() => {
    "identitySource": identitySource,
    "identity": identity,
    "systemIP": systemIp,
  };
}