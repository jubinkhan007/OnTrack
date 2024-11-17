import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:tmbi/widgets/file_attachment.dart';

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

  Future<bool> saveInquiry(
      String companyId,
      String inquiryId,
      String inquiryName,
      String inquiryDesc,
      String isSample,
      String neededDate,
      String priorityId,
      String customerId,
      String customerName,
      String userId,
      List<String> fileNames) async {
    try {
      final headers = {
        "compid": companyId,
        "custid": customerId,
        "inqrid": inquiryId,
        "inqrname": inquiryName,
        "inqrdesc": inquiryDesc,
        "salmpleflag": isSample,
        "needdate": neededDate,
        "userid": userId,
        "custname": customerName,
        "priorityid": priorityId,
        "files": fileNames.length
      };

      // set file names
      for (var i = 0; i < fileNames.length; i++) {
        headers['picture${i + 1}'] = fileNames[i];
      }

      final response = await dio.post(
        "saveall",
        options: Options(headers: headers),
      );
      debugPrint("RESPONSE#${response.data}");
      return response.data['status'] == "200";
    } on DioException catch (error) {
      throw Exception(error);
    }
  }

  Future<List<Map<String, dynamic>>> saveImages(List<ImageFile> files,
      {String id = "XXXX", String dbId = "XXX"}) async {
    final formData = FormData();
    formData.fields.add(MapEntry('challanno', id));
    formData.fields.add(MapEntry('dbid', dbId));

    for (var i = 0; i < files.length; i++) {
      formData.files.add(MapEntry(
        'files',
        MultipartFile.fromBytes(
          files[i].file,
          filename: files[i].name, // Provide a unique filename for each file
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
        throw Exception(
            'Received an error with status code:: ${response.data}');
      }
    } on DioException catch (error) {
      debugPrint("File upload failed:: $error");
      throw Exception(error);
    }
  }

  /// DEMO API

  Future<List<InquiryResponse>> getInquiries() async {
    try {
      final response = await dio.get("6a2a424e53a984ad4ea3");
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
      debugPrint("Error fetching inquiries: $error");
      throw Exception(error);
    }
  }

  Future<String> getCount() async {
    try {
      final response = await dio.get("0b50f5fa2214288a80f0");
      // check if the response data is a Map and contains the 'count' key
      if (response.data is Map<String, dynamic> &&
          response.data.containsKey('count')) {
        // access the count value
        final String count = response.data['count'];
        return count;
      } else {
        return "0"; // return 0 if 'count' is not available
      }
    } on DioException catch (error) {
      debugPrint("Error fetching count: $error");
      throw Exception(error);
    }
  }

  Future<AttachmentViewResponse> getAttachments() async {
    try {
      final response = await dio.get("5dedf78a78969c55cfb3");
      debugPrint("RESPONSE#${response.data}");
      return AttachmentViewResponse.fromJson(response.data);
    } on DioException catch (error) {
      throw Exception(error);
    }
  }

  Future<NoteResponse> getNotes() async {
    try {
      final response = await dio.get("2a2ecc5de4a852629548");
      debugPrint("RESPONSE#${response.data}");
      return NoteResponse.fromJson(response.data);
    } on DioException catch (error) {
      throw Exception(error);
    }
  }

  Future<CommentResponse> getComments() async {
    try {
      final response = await dio.get("c129b21084d6208d2753");
      debugPrint("RESPONSE#${response.data}");
      return CommentResponse.fromJson(response.data);
    } on DioException catch (error) {
      throw Exception(error);
    }
  }

}
