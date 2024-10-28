import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../models/models.dart';

class InquiryRepo {
  final Dio dio;

  InquiryRepo({required this.dio});

  Future<InitDataCreateInq> getInitDataForCreateInquiry() async {
    try {
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

  /*Future<InquiryResponse> getInquiries() async {
    try {
      final response = await dio.get(
        "",
      );
      debugPrint("RESPONSE#${response.data}");
      return InquiryResponse.fromJson(response.data);
    } on DioException catch (error) {
      throw Exception(error);
    }
  }*/

  Future<List<InquiryResponse>> getInquiries() async {
    try {
      final response = await dio.get("");
      debugPrint("RESPONSE#${response.data}");
      // check if the response data is a Map and contains 'queries'
      if (response.data is Map<String, dynamic> &&
          response.data.containsKey('queries')) {
        final List<dynamic> inquiriesJson = response.data['queries'] ?? [];
        // map the list of JSON objects to InquiryResponse objects
        return inquiriesJson
            .map((json) => InquiryResponse.fromJson(json))
            .toList();
      } else {
        return [];
      }
    } on DioException catch (error) {
      debugPrint("error fetching inquiries: $error");
      throw Exception(error);
    }
  }
}
