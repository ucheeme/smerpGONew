// To parse this JSON data, do
//
//     final collectionList = collectionListFromJson(jsonString);

import 'dart:convert';

List<CollectionList> collectionListFromJson(String str) => List<CollectionList>.from(json.decode(str).map((x) => CollectionList.fromJson(x)));

String collectionListToJson(List<CollectionList> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CollectionList {
  int collectionId;
  String merchantCode;
  String name;
  String description;
  String avatar;
  String collectionUrl;
  int collectionItemCount;

  CollectionList({
    required this.collectionId,
    required this.merchantCode,
    required this.name,
    required this.description,
    required this.avatar,
    required this.collectionItemCount,
    required this.collectionUrl
  });

  factory CollectionList.fromJson(Map<String, dynamic> json) => CollectionList(
    collectionId: json["collectionId"],
    merchantCode: json["merchantCode"],
    name: json["name"],
    description: json["description"],
    avatar: json["avatar"],
    collectionItemCount: json['items'],
    collectionUrl: json['collectionUrl']
  );

  Map<String, dynamic> toJson() => {
    "collectionId": collectionId,
    "merchantCode": merchantCode,
    "name": name,
    "description": description,
    "avatar": avatar,
    "items":collectionItemCount,
    "collectionUrl":collectionUrl
  };
}
