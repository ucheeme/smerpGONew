// To parse this JSON data, do
//
//     final createAccount = createAccountFromJson(jsonString);

import 'dart:convert';

CreateAccount createAccountFromJson(String str) => CreateAccount.fromJson(json.decode(str));

String createAccountToJson(CreateAccount data) => json.encode(data.toJson());

class CreateAccount {
  int identitySource;
  String identity;
  String systemIp;

  CreateAccount({
    required this.identitySource,
    required this.identity,
    required this.systemIp,
  });

  factory CreateAccount.fromJson(Map<String, dynamic> json) => CreateAccount(
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
