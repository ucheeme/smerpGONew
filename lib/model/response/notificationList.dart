import 'dart:convert';
List<NotificationList> notificationListFromJson(String str) => List<NotificationList>.from(json.decode(str).map((x) => NotificationList.fromJson(x)));

String notificationListToJson(List<NotificationList> data) =>  json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class NotificationList {
  String? title;
  String? body;
  int? id;
  String? type;
  String? orderId;
  String? createdOn;
  NotificationList({
    required this.title,
    required this.body,
    required this.createdOn,
    required this.id,
    this.orderId,
    required this.type
  });

  factory NotificationList.fromJson(Map<String, dynamic> json)=>NotificationList(
      title: json['title'],
      body: json['body'],
      id: json['id'],
      type: json['type'],
      orderId: json['orderId'],
      createdOn:  json['createdOn']
  );

  Map<String, dynamic> toJson()=> {
    'title':title,
    'body': body,
    'id':id,
    'type':type,
    'orderId':orderId,
    'createdOn': createdOn
  };

}