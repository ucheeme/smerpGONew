// To parse this JSON data, do
//
//     final creatBankDetailReponse = creatBankDetailReponseFromJson(jsonString);

import 'dart:convert';

CreatBankDetailReponse creatBankDetailReponseFromJson(String str) => CreatBankDetailReponse.fromJson(json.decode(str));

String creatBankDetailReponseToJson(CreatBankDetailReponse data) => json.encode(data.toJson());

class CreatBankDetailReponse {

  dynamic data;

  CreatBankDetailReponse({

    required this.data,
  });

  factory CreatBankDetailReponse.fromJson(Map<String, dynamic> json) => CreatBankDetailReponse(

    data: json["data"],
  );

  Map<String, dynamic> toJson() => {
    "data": data,
  };
}
