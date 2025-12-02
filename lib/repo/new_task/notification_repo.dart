import 'package:dio/dio.dart';
import 'package:flutter/material.dart' hide Notification;

import '../../models/new_task/notification_response.dart';

class NotificationRepo {
  final Dio dio;

  NotificationRepo({required this.dio});

  Future<List<Notification>> getNotification(String staffId) async {
    try {
      final headers = {
        'vm': 'GET_NOTIF',
        'va': '0',
        'vb': staffId,
        'vc': '0',
        'vd': 'Data',
      };
      final response = await dio.get(
        "getall",
        options: Options(headers: headers),
      );
      debugPrint("RESPONSE#${response.data}");
      final parsed = NotificationResponse.fromJson(response.data);
      return parsed.data;
    } on DioException catch (error) {
      throw Exception(error);
    }
  }
}
