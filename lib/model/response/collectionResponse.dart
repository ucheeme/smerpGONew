// To parse this JSON data, do
//
//     final collectionResponse = collectionResponseFromJson(jsonString);

import 'dart:convert';

CollectionCreatedResponse collectionResponseFromJson(String str) => CollectionCreatedResponse.fromJson(json.decode(str));

String collectionResponseToJson(CollectionCreatedResponse data) => json.encode(data.toJson());

class CollectionCreatedResponse {
  String url;

  CollectionCreatedResponse({
    required this.url,
  });

  factory CollectionCreatedResponse.fromJson(Map<String, dynamic> json) => CollectionCreatedResponse(
    url: json["url"],
  );

  Map<String, dynamic> toJson() => {
    "url": url,
  };
}