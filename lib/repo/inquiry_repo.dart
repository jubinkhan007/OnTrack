import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../models/models.dart';

class InquiryRepo {
  final Dio dio;

  InquiryRepo({required this.dio});

  Future<InitDataCreateInq> getInitDataForCreateInquiry() async {
    try {
      /*final response = await dio.get(
        "",
      );*/
      final headers = {
        'vm': 'COMP',
        'va': '5',
        'vb': '340553',
        'vc': '123456',
        'vd': 'company',
      };
      final response = await dio.get(
        "getall",
        options: Options(headers: headers),
      );
      debugPrint("RESPONSE#${response.data}");
      return InitDataCreateInq.fromJson(response.data);
    } on DioException catch (error) {
      throw Exception(error);
    }
  }
}
