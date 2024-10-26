import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../models/models.dart';

class InquiryRepo {
  final Dio dio;

  InquiryRepo({required this.dio});

  Future<InitDataCreateInq> getInitDataForCreateInquiry() async {
    try {
      final response = await dio.get(
        "",
      );
      debugPrint("RESPONSE#${response.data}");
      return InitDataCreateInq.fromJson(response.data);
    } on DioException catch (error) {
      throw Exception(error);
    }
  }
}
