import 'dart:math';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  void requestNotificationPermission() async {
    NotificationSettings notificationSettings =
        await firebaseMessaging.requestPermission(
            alert: true,
            // Show notification on the device
            announcement: true,
            // Siri or other voice assistants read notifications
            badge: true,
            // Count on the app icon
            carPlay: true,
            criticalAlert: true,
            provisional: true,
            // User has the ability to turn it off
            sound: true);

    if (notificationSettings.authorizationStatus ==
        AuthorizationStatus.authorized) {
      debugPrint("Permission has been granted to send notifications.");
    } else if (notificationSettings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      debugPrint("Permission has been provisionally granted.");
    } else {
      debugPrint("Permission has been denied.");
    }
  }

  void initLocalNotification(
      BuildContext context, RemoteMessage message) async {
    var androidInitSettings =
        const AndroidInitializationSettings('@drawable/ic_noti');
    var iosInitSettings = const DarwinInitializationSettings();
    var initSetting = InitializationSettings(
        android: androidInitSettings, iOS: iosInitSettings);

    await _flutterLocalNotificationsPlugin.initialize(initSetting,
        onDidReceiveNotificationResponse: (payload) {});
  }

  void firebaseInit() {
    FirebaseMessaging.onMessage.listen((message) {
      showNotification(message);
    });
  }

  Future<void> showNotification(RemoteMessage message) async {
    AndroidNotificationChannel anChannel = AndroidNotificationChannel(
        Random.secure().nextInt(100000).toString(),
        "high_importance_channel",
        importance: Importance.max);

    AndroidNotificationDetails anDetails = AndroidNotificationDetails(
      anChannel.id.toString(),
      anChannel.name.toString(),
      channelDescription: "Track all app notification channel description",
      importance: Importance.high,
      priority: Priority.high,
      ticker: "ticker",
      icon: '@drawable/ic_noti'
    );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    NotificationDetails notificationDetails = NotificationDetails(
      android: anDetails,
      iOS: iosDetails,
    );

    Future.delayed(Duration.zero, () {
      _flutterLocalNotificationsPlugin.show(
          1,
          message.notification != null
              ? message.notification!.title.toString()
              : "",
          message.notification != null
              ? message.notification!.body.toString()
              : "",
          notificationDetails);
    });
  }

  /// Firebase sends notifications according to the device ID, not the Firebase ID.
  Future<String?> getDeviceToken() async {
    return await firebaseMessaging.getToken();
  }

  void isTokenRefresh() {
    firebaseMessaging.onTokenRefresh.listen((event) {
      event.toString();
    });
  }
}
