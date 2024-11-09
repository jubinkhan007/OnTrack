import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../models/models.dart';

class InquiryRepo {
  final Dio dio;
  final Dio fileDio;

  InquiryRepo({required this.fileDio, required this.dio});

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

  Future<List<Map<String, dynamic>>> saveImages(
      List<Uint8List> files, List<String> paths,
      {String id = "XXXX", String dbId = "XXX"}) async {
    final formData = FormData();
    formData.fields.add(MapEntry('challanno', id));
    formData.fields.add(MapEntry('dbid', dbId));

    for (var i = 0; i < files.length; i++) {
      formData.files.add(MapEntry(
        'files',
        MultipartFile.fromBytes(
          files[i],
          filename: paths[i], // Provide a unique filename for each file
        ),
      ));
    }
    // save image into server
    try {
      final response = await fileDio.post("ImageUpload/upload", data: formData);
      debugPrint("RESPONSE#${response.data}");

      if (response.statusCode == 200) {
        // ensure response.data is a List<dynamic>
        if (response.data is List) {
          // map the response to List<Map<String, dynamic>>
          return (response.data as List)
              .map((item) => Map<String, dynamic>.from(item))
              .toList();
        } else {
          throw Exception('Unexpected response format:: ${response.data}');
        }
      } else {
        throw Exception('Received an error with status code:: ${response.data}');
      }

    } on DioException catch (error) {
      debugPrint("File upload failed:: $error");
      throw Exception(error);
    }
  }
}
