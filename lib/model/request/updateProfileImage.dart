// To parse this JSON data, do
//
//     final profileImageUpdate = profileImageUpdateFromJson(jsonString);

import 'dart:convert';

ProfileImageUpdate profileImageUpdateFromJson(String str) => ProfileImageUpdate.fromJson(json.decode(str));

String profileImageUpdateToJson(ProfileImageUpdate data) => json.encode(data.toJson());

class ProfileImageUpdate {
  String actionBy;
  DateTime actionOn;
  String imageString;

  ProfileImageUpdate({
    required this.actionBy,
    required this.actionOn,
    required this.imageString,
  });

  factory ProfileImageUpdate.fromJson(Map<String, dynamic> json) => ProfileImageUpdate(
    actionBy: json["actionBy"],
    actionOn: DateTime.parse(json["actionOn"]),
    imageString: json["imageString"],
  );

  Map<String, dynamic> toJson() => {
    "actionBy": actionBy,
    "actionOn": actionOn.toIso8601String(),
    "imageString": imageString,
  };
}
