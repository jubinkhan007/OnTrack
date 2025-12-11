import 'dart:math';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
/*
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

  /// Firebase sends notifications according
  /// to the device ID, not the Firebase ID.
  Future<String?> getDeviceToken() async {
    return await firebaseMessaging.getToken();
  }

  void isTokenRefresh() {
    firebaseMessaging.onTokenRefresh.listen((event) {
      event.toString();
    });
  }
}*/
import 'dart:math';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
/*
class NotificationService {
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  // ------------------------------
  // 1. Request iOS notification permissions
  // ------------------------------
  Future<void> requestNotificationPermission() async {
    NotificationSettings settings =
    await firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      announcement: true,
      provisional: false,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      debugPrint("Permission granted.");
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      debugPrint("Provisional permission granted.");
    } else {
      debugPrint("Permission denied.");
    }
  }

  // ------------------------------
  // 2. Get FCM token (iOS-safe)
  // ------------------------------
  Future<String?> getDeviceToken() async {
    // iOS: wait for APNs token first
    String? apnsToken = await firebaseMessaging.getAPNSToken();
    if (apnsToken == null) {
      debugPrint("❌ APNs token not ready yet");
      return null;
    }
    debugPrint("✔ APNs Token: $apnsToken");

    String? fcmToken = await firebaseMessaging.getToken();
    debugPrint("✔ FCM Token: $fcmToken");

    return fcmToken;
  }

  // ------------------------------
  // 3. Listen for token refresh
  // ------------------------------
  void listenTokenRefresh() {
    firebaseMessaging.onTokenRefresh.listen((newFCMToken) async {
      debugPrint("🔄 FCM Token refreshed: $newFCMToken");
      String? apns = await firebaseMessaging.getAPNSToken();
      debugPrint("🔄 Updated APNs Token: $apns");
    });
  }

  // ------------------------------
  // 4. Initialize local notifications
  // ------------------------------
  Future<void> initLocalNotification() async {
    const androidSettings = AndroidInitializationSettings('@drawable/ic_noti');
    const iosSettings = DarwinInitializationSettings();

    final initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _flutterLocalNotificationsPlugin.initialize(initSettings);
  }

  // ------------------------------
  // 5. Listen for foreground messages
  // ------------------------------
  void firebaseInit() {
    FirebaseMessaging.onMessage.listen((message) {
      showNotification(message);
    });
  }

  // ------------------------------
  // 6. Show notification
  // ------------------------------
  Future<void> showNotification(RemoteMessage message) async {
    AndroidNotificationChannel channel = AndroidNotificationChannel(
      Random.secure().nextInt(999999).toString(),
      "high_importance_channel",
      importance: Importance.max,
    );

    AndroidNotificationDetails androidDetails =
    AndroidNotificationDetails(
      channel.id,
      channel.name,
      channelDescription:
      "Track all app notification channel description",
      importance: Importance.high,
      priority: Priority.high,
      icon: '@drawable/ic_noti',
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    _flutterLocalNotificationsPlugin.show(
      1,
      message.notification?.title ?? "",
      message.notification?.body ?? "",
      details,
    );
  }
}
*/

import 'dart:io';
import 'dart:math';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  final FirebaseMessaging _firebase = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _local =
  FlutterLocalNotificationsPlugin();

  // ------------------------------------------------------------
  // 1. Request permission (iOS only)
  // ------------------------------------------------------------
  Future<void> requestNotificationPermission() async {
    NotificationSettings settings = await _firebase.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      announcement: false,
      provisional: false,
    );

    debugPrint("Permission Status: ${settings.authorizationStatus}");
  }

  // ------------------------------------------------------------
  // 2. Initialize local notifications (Android + iOS)
  // ------------------------------------------------------------
  Future<void> initLocalNotification() async {
    const androidSettings = AndroidInitializationSettings('@drawable/ic_noti');
    const iosSettings = DarwinInitializationSettings();
    const initSettings =
    InitializationSettings(android: androidSettings, iOS: iosSettings);

    await _local.initialize(initSettings);
  }

  // ------------------------------------------------------------
  // 3. Firebase messaging listener (foreground)
  // ------------------------------------------------------------
  void firebaseInit() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      showNotification(message);
    });
  }

  // ------------------------------------------------------------
  // 4. Retrieve FCM token (Android + iOS)
  // ------------------------------------------------------------
  /*Future<String?> getDeviceToken() async {
    // iOS requires APNs to be ready before FCM token works
    if (Platform.isIOS) {
      String? apns = await _firebase.getAPNSToken();
      if (apns == null) {
        debugPrint("APNs token not ready, waiting...");
        await Future.delayed(const Duration(seconds: 2));
        apns = await _firebase.getAPNSToken();
      }

      debugPrint("APNs token: $apns");
    }

    // Try to get FCM token
    String? fcmToken = await _firebase.getToken();

    // Android sometimes needs a retry
    if (fcmToken == null) {
      debugPrint("FCM token null, retrying...");
      await Future.delayed(const Duration(seconds: 2));
      fcmToken = await _firebase.getToken();
    }

    debugPrint("FCM Token: $fcmToken");
    return fcmToken;
  }*/

  Future<String?> getDeviceToken() async {
    // ---------------------------
    // iOS: APNs token required
    // ---------------------------
    if (Platform.isIOS) {
      String? apnsToken = await _firebase.getAPNSToken();
      if (apnsToken == null) {
        debugPrint("Waiting for APNs...");
        await Future.delayed(const Duration(seconds: 2));
        apnsToken = await _firebase.getAPNSToken();
      }
      debugPrint("APNs Token: $apnsToken");
    }

    // ---------------------------
    // Android + iOS: Get FCM
    // ---------------------------
    String? fcm = await _firebase.getToken();

    if (fcm == null) {
      debugPrint("Retrying FCM token...");
      await Future.delayed(const Duration(seconds: 2));
      fcm = await _firebase.getToken();
    }

    debugPrint("FCM Token: $fcm");
    return fcm;
  }


  // ------------------------------------------------------------
  // 5. Listen for token refresh
  // ------------------------------------------------------------
  void listenTokenRefresh() {
    _firebase.onTokenRefresh.listen((token) {
      debugPrint("FCM Token refreshed: $token");
    });
  }

  // ------------------------------------------------------------
  // 6. Show notification (foreground)
  // ------------------------------------------------------------
  Future<void> showNotification(RemoteMessage message) async {
    final channel = AndroidNotificationChannel(
      Random.secure().nextInt(999999).toString(),
      "high_importance_channel",
      importance: Importance.max,
    );

    final androidDetails = AndroidNotificationDetails(
      channel.id,
      channel.name,
      channelDescription: "Default notification channel",
      importance: Importance.high,
      priority: Priority.high,
      icon: '@drawable/ic_noti',
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    final details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    _local.show(
      1,
      message.notification?.title ?? "New Notification",
      message.notification?.body ?? "",
      details,
    );
  }
}
