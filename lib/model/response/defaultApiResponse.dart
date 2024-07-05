// To parse this JSON data, do
//
//     final defaultApiResponse = defaultApiResponseFromJson(jsonString);

import 'dart:convert';

DefaultApiResponse defaultApiResponseFromJson(String str) => DefaultApiResponse.fromJson(json.decode(str));

String defaultApiResponseToJson(DefaultApiResponse data) => json.encode(data.toJson());

class DefaultApiResponse {
  bool isSuccess;
  String message;
  dynamic data;

  DefaultApiResponse({
    required this.isSuccess,
    required this.message,
    this.data,
  });

  factory DefaultApiResponse.fromJson(Map<String, dynamic> json) => DefaultApiResponse(
    isSuccess: json["isSuccess"],
    message: json["message"],
    data: (json["data"] == null)?json["isSuccess"]: json["data"],
  );

  Map<String, dynamic> toJson() => {
    "isSuccess": isSuccess,
    "message": message,
    "data": data,
  };
}