// To parse this JSON data, do
//
//     final loginResponse = loginResponseFromJson(jsonString);

import 'dart:convert';

LoginResponse loginResponseFromJson(String str) => LoginResponse.fromJson(json.decode(str));

String loginResponseToJson(LoginResponse data) => json.encode(data.toJson());

class LoginResponse {
  bool isSuccess;
  String message;
  LoginData? data;

  LoginResponse({
    required this.isSuccess,
    required this.message,
     this.data,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
    isSuccess: json["isSuccess"],
    message: json["message"],
    data:(json["data"]==null)?null: LoginData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "isSuccess": isSuccess,
    "message": message,
    "data": data?.toJson(),
  };
}

class LoginData {
  String userId;
  String firstName;
  String lastName;
  String? email;
  String? phoneNumber;
  String storeName;
  String? deviceMIME;
  String? deviceId;
  String? deviceType;
  String? storePhoneNumber;
  String? storeEmail;
  String merchantCode;
  String storeLink;
  String avatar;
  String token;

  LoginData({
    required this.userId,
    required this.firstName,
    required this.lastName,
    this.email,
     this.deviceId,
     this.deviceMIME,
     this.deviceType,
     this.phoneNumber,
    required this.storeName,
    required this.merchantCode,
    required this.storeLink,
     this.storePhoneNumber,
     this.storeEmail,
    required this.avatar,
    required this.token,
  });

  factory LoginData.fromJson(Map<String, dynamic> json) => LoginData(
    userId: json["userId"],
    firstName: json["firstName"],
    lastName: json["lastName"],
    email: json["email"],
    phoneNumber: json["phoneNumber"],
    storeName: json["storeName"],
    merchantCode: json["merchantCode"],
    storeLink: json["storeLink"],
    storePhoneNumber: json["storePhoneNumber"],
    storeEmail: json["storeEmailAddress"],
    avatar: json["avatar"],
    token: json["token"],
    deviceId: json['deviceId'],
    deviceMIME: json['deviceMIME'],
    deviceType: json['deviceType']
  );

  Map<String, dynamic> toJson() => {
    "userId": userId,
    "firstName": firstName,
    "lastName": lastName,
    "email": email,
    "phoneNumber": phoneNumber,
    "storeName": storeName,
    "merchantCode": merchantCode,
    "storeLink":storeLink,
    "storePhoneNumber":storePhoneNumber,
    "storeEmailAddress":storeEmail,
    "avatar": avatar,
    "token": token,
    "deviceMIME":deviceMIME,
    "deviceId":deviceId,
    "deviceType":deviceType
  };
}
