// To parse this JSON data, do
//
//     final profileImageUpdateResponse = profileImageUpdateResponseFromJson(jsonString);

import 'dart:convert';

ProfileImageUpdateResponse profileImageUpdateResponseFromJson(String str) => ProfileImageUpdateResponse.fromJson(json.decode(str));

String profileImageUpdateResponseToJson(ProfileImageUpdateResponse data) => json.encode(data.toJson());

class ProfileImageUpdateResponse {
  bool isSuccess;
  String message;
  dynamic data;

  ProfileImageUpdateResponse({
    required this.isSuccess,
    required this.message,
     this.data,
  });

  factory ProfileImageUpdateResponse.fromJson(Map<String, dynamic> json) => ProfileImageUpdateResponse(
    isSuccess: json["isSuccess"],
    message: json["message"],
    data: json["data"],
  );

  Map<String, dynamic> toJson() => {
    "isSuccess": isSuccess,
    "message": message,
    "data": data,
  };
}
