// To parse this JSON data, do
//
//     final createCollection = createCollectionFromJson(jsonString);

import 'dart:convert';

CreateCollection createCollectionFromJson(String str) => CreateCollection.fromJson(json.decode(str));

String createCollectionToJson(CreateCollection data) => json.encode(data.toJson());

class CreateCollection {
  String actionBy;
  DateTime actionOn;
  String name;
  String description;
  String avatar;
  String merchantCode;
  List<int> productIds;

  CreateCollection({
    required this.actionBy,
    required this.actionOn,
    required this.name,
    required this.description,
    required this.avatar,
    required this.merchantCode,
    required this.productIds,
  });

  factory CreateCollection.fromJson(Map<String, dynamic> json) => CreateCollection(
    actionBy: json["actionBy"],
    actionOn: DateTime.parse(json["actionOn"]),
    name: json["name"],
    description: json["description"],
    avatar: json["avatar"],
    merchantCode: json["merchantCode"],
    productIds: List<int>.from(json["productIds"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "actionBy": actionBy,
    "actionOn": actionOn.toIso8601String(),
    "name": name,
    "description": description,
    "avatar": avatar,
    "merchantCode": merchantCode,
    "productIds": List<dynamic>.from(productIds.map((x) => x)),
  };
}
