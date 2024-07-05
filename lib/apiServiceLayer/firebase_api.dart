import 'dart:convert';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

import '../main.dart';
import '../screens/bottomsheets/notification.dart';
import '../utils/slideUpRoute.dart';

class FirebaseApi{
  final _firebaseMessaging = FirebaseMessaging.instance;
final androidChannel = const AndroidNotificationChannel(
'high_importance_channel', 'High Importanc Notifications',
description: 'This channel is used for important notification',
importance: Importance.defaultImportance);

  Future<void> handleBackgroundMessage(RemoteMessage message) async{
    print('Title: ${message.notification?.title}');
    print('Body: ${message.notification?.body}');
    print('Payload: ${message.data}');
    if(message.isNull) return;
    Get.to(SlideUpRoute(page: NotificationApp()));
  }

  Future<void> handleMessage(RemoteMessage? message) async{

    if(message==null) return;
    Get.to(SlideUpRoute(page: NotificationApp()));
  }
  Future initPushNotifications()async{
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true
    );
    FirebaseMessaging.instance.getInitialMessage().then(handleMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
   FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
  }

  Future<void> initNotifications()async{
    await _firebaseMessaging.requestPermission();
    final deviceTokenT = await _firebaseMessaging.getToken();
   String deviceTokenEE=deviceTokenT!;
    print("Token: $deviceTokenT");
  initPushNotifications();
  }
}

