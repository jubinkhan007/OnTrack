import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:tmbi/config/app_navigator.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FirebaseMessaging _firebase = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _local =
      FlutterLocalNotificationsPlugin();

  static const String reminderChannelId = "task_reminders";
  static const String reminderChannelName = "Task Reminders";

  bool _initialized = false;
  bool _tzInitialized = false;

  Future<void> requestNotificationPermission() async {
    // Android 13+ is handled via local plugin permission request.
    if (!Platform.isIOS) return;
    final settings = await _firebase.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    debugPrint("Permission status: ${settings.authorizationStatus}");
  }

  Future<void> _ensureTimeZoneReady() async {
    if (_tzInitialized) return;
    tz.initializeTimeZones();
    try {
      final tzName = await FlutterNativeTimezone.getLocalTimezone();
      try {
        tz.setLocalLocation(tz.getLocation(tzName));
        debugPrint("[REMINDER] tz: using '$tzName'");
      } catch (_) {
        // Some devices return "GMT+06:00" style IDs which aren't IANA names.
        final offset = DateTime.now().timeZoneOffset;
        final h = offset.inHours;
        final m = offset.inMinutes.abs() % 60;
        if (m != 0) {
          tz.setLocalLocation(tz.getLocation("UTC"));
          debugPrint(
            "[REMINDER] tz: fallback UTC (non-hour offset=${offset.inMinutes}min, raw='$tzName')",
          );
        } else {
          // Etc/GMT+5 is UTC-5. Sign is inverted for Etc/GMT.
          final sign = h >= 0 ? "-" : "+";
          final etc = "Etc/GMT$sign${h.abs()}";
          tz.setLocalLocation(tz.getLocation(etc));
          debugPrint(
            "[REMINDER] tz: fallback '$etc' (offset=${offset.inMinutes}min, raw='$tzName')",
          );
        }
      }
    } catch (_) {
      // Fallback to UTC if timezone cannot be resolved.
      tz.setLocalLocation(tz.getLocation("UTC"));
      debugPrint("[REMINDER] tz: fallback UTC (timezone plugin failed)");
    }
    _tzInitialized = true;
  }

  Future<void> initLocalNotification({bool requestPermissions = true}) async {
    const androidSettings = AndroidInitializationSettings('@drawable/ic_noti');
    const iosSettings = DarwinInitializationSettings();
    const initSettings =
        InitializationSettings(android: androidSettings, iOS: iosSettings);

    await _local.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (details) async {
        final payload = details.payload;
        if (payload == null || payload.isEmpty) return;
        _handleNotificationTap(payload);
      },
    );

    final androidPlugin =
        _local.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    if (androidPlugin != null) {
      if (requestPermissions) {
        final granted = await androidPlugin.requestNotificationsPermission();
        final enabled = await androidPlugin.areNotificationsEnabled();
        debugPrint(
          "[REMINDER] notifPermission init: request=$granted enabled=$enabled",
        );
      }
      await androidPlugin.createNotificationChannel(
        const AndroidNotificationChannel(
          reminderChannelId,
          reminderChannelName,
          description: "Task due-date reminders",
          importance: Importance.high,
        ),
      );
    }

    final iosPlugin =
        _local.resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>();
    if (iosPlugin != null && requestPermissions) {
      final granted = await iosPlugin.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
      final enabled = await iosPlugin.checkPermissions();
      debugPrint(
        "[REMINDER] iosPermission init: request=$granted enabled=${enabled?.isEnabled}",
      );
    }

    // If the app was launched by tapping a local notification, handle it.
    try {
      final details = await _local.getNotificationAppLaunchDetails();
      final payload = details?.notificationResponse?.payload;
      if (payload != null && payload.isNotEmpty) {
        _handleNotificationTap(payload);
      }
    } catch (_) {
      // Ignore.
    }

    _initialized = true;
  }

  Future<void> ensureInitialized() async {
    await requestNotificationPermission();
    if (!_initialized) {
      await initLocalNotification(requestPermissions: true);
      return;
    }

    // We may have initialized without requesting runtime permission (e.g. app
    // startup). Request it here so scheduling works on Android 13+.
    final androidPlugin =
        _local.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    if (androidPlugin != null) {
      final granted = await androidPlugin.requestNotificationsPermission();
      final enabled = await androidPlugin.areNotificationsEnabled();
      debugPrint(
        "[REMINDER] notifPermission ensure: request=$granted enabled=$enabled",
      );
    }

    final iosPlugin =
        _local.resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>();
    if (iosPlugin != null) {
      final granted = await iosPlugin.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
      final enabled = await iosPlugin.checkPermissions();
      debugPrint(
        "[REMINDER] iosPermission ensure: request=$granted enabled=${enabled?.isEnabled}",
      );
    }
  }

  Future<bool> canPostNotifications() async {
    await ensureInitialized();
    final androidPlugin =
        _local.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    if (androidPlugin != null) {
      final enabled = await androidPlugin.areNotificationsEnabled();
      return enabled ?? true;
    }

    final iosPlugin =
        _local.resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>();
    if (iosPlugin != null) {
      final enabled = await iosPlugin.checkPermissions();
      return enabled?.isEnabled ?? true;
    }

    return true;
  }

  void firebaseInit() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint("Foreground message received");
      showNotification(message);
    });
  }

  Future<String?> getDeviceToken() async {
    if (Platform.isIOS) {
      final apnsToken = await _firebase.getAPNSToken();
      if (apnsToken == null) {
        debugPrint("iOS Simulator detected – APNs not available");
        return null;
      }
    }

    String? fcmToken = await _firebase.getToken();
    if (fcmToken == null) {
      await Future.delayed(const Duration(seconds: 2));
      fcmToken = await _firebase.getToken();
    }
    debugPrint("FCM Token: $fcmToken");
    return fcmToken;
  }

  void listenTokenRefresh() {
    _firebase.onTokenRefresh.listen((token) {
      debugPrint("FCM Token refreshed: $token");
    });
  }

  Future<void> showNotification(RemoteMessage message) async {
    await ensureInitialized();

    final androidDetails = AndroidNotificationDetails(
      reminderChannelId,
      reminderChannelName,
      channelDescription: "App notifications",
      importance: Importance.high,
      priority: Priority.high,
      icon: '@drawable/ic_noti',
    );
    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    final details = NotificationDetails(android: androidDetails, iOS: iosDetails);

    await _local.show(
      0,
      message.notification?.title ?? 'New Notification',
      message.notification?.body ?? '',
      details,
      payload: message.data.isNotEmpty ? jsonEncode(message.data) : null,
    );
  }

  Future<void> scheduleReminder({
    required int id,
    required DateTime scheduledAt,
    required String title,
    required String body,
    required Map<String, dynamic> payload,
  }) async {
    await ensureInitialized();

    final canPost = await canPostNotifications();
    debugPrint("[REMINDER] canPost=$canPost");
    if (!canPost) {
      debugPrint("[REMINDER] blocked: notifications disabled/denied");
      return;
    }

    await _ensureTimeZoneReady();
    debugPrint(
      "[REMINDER] schedule id=$id at=${scheduledAt.toIso8601String()} payload=${jsonEncode(payload)}",
    );

    final androidDetails = AndroidNotificationDetails(
      reminderChannelId,
      reminderChannelName,
      channelDescription: "Task due-date reminders",
      importance: Importance.high,
      priority: Priority.high,
      icon: '@drawable/ic_noti',
    );
    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    final details = NotificationDetails(android: androidDetails, iOS: iosDetails);

    final tzTime = tz.TZDateTime.from(scheduledAt, tz.local);
    debugPrint(
      "[REMINDER] zonedSchedule id=$id tz=${tz.local.name} tzTime=${tzTime.toIso8601String()}",
    );

    // Use inexact scheduling by default.
    //
    // Exact alarms have extra user-facing restrictions on newer Android
    // versions and can be disabled (greyed out) depending on OS policy.
    // Inexact reminders are still reliable enough for "self reminders" and
    // do not require special access.
    final AndroidScheduleMode mode = AndroidScheduleMode.inexactAllowWhileIdle;

    try {
      await _local.zonedSchedule(
        id,
        title,
        body,
        tzTime,
        details,
        androidScheduleMode: mode,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        payload: jsonEncode(payload),
      );
      debugPrint("[REMINDER] scheduled with mode=$mode");
    } catch (e) {
      // If exact alarms aren't allowed, fallback to inexact so user still gets reminders.
      debugPrint("[REMINDER] zonedSchedule failed mode=$mode error=$e (fallback inexact)");
      await _local.zonedSchedule(
        id,
        title,
        body,
        tzTime,
        details,
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        payload: jsonEncode(payload),
      );
    }

    try {
      final pending = await _local.pendingNotificationRequests();
      debugPrint("[REMINDER] pending count=${pending.length}");
    } catch (_) {
      // Ignore.
    }
  }

  Future<void> cancelReminder(int id) async {
    await ensureInitialized();
    debugPrint("[REMINDER] cancel id=$id");
    await _local.cancel(id);
  }

  void _handleNotificationTap(String payload) {
    try {
      debugPrint("[REMINDER] tap payload=$payload");
      final decoded = jsonDecode(payload) as Map<String, dynamic>;
      final staffId = (decoded["staffId"] ?? "").toString();
      final taskId = (decoded["taskId"] ?? "").toString();
      final assignName = (decoded["assignName"] ?? "You").toString();
      if (staffId.isEmpty || taskId.isEmpty) return;
      AppNavigator.openTaskDetails(
        staffId: staffId,
        taskId: taskId,
        assignName: assignName,
      );
    } catch (_) {
      // Ignore malformed payloads.
    }
  }
}
