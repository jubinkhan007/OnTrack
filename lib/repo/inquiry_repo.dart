import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:tmbi/widgets/file_attachment.dart';
import 'package:http_parser/http_parser.dart';

import '../models/image_file.dart';
import '../models/models.dart';

class InquiryRepo {
  final Dio dio;
  final Dio fileDio;

  InquiryRepo({required this.fileDio, required this.dio});

  Future<InitDataCreateInq> getInitDataForCreateInquiry(String staffId) async {
    try {
      final headers = {
        'vm': 'COMP',
        'va': '5',
        'vb': staffId,
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
      String tasks,
      List<String> fileNames) async {
    try {
      final headers = {
        "dtype": "INQUERY",
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
        "taskdetail": tasks,
        "files": fileNames.length
      };

      // set file names
      for (var i = 0; i < fileNames.length; i++) {
        headers['picture${i + 1}'] = fileNames[i];
      }

      final response = await dio.post(
        //"saveall2",
        "saveall",
        options: Options(headers: headers),
      );
      debugPrint("RESPONSE#${response.data}");
      return response.data['status'] == "200";
    } on DioException catch (error) {
      debugPrint("RESPONSE_ERROR#$error");
      throw Exception(error);
    }
  }

  Future<bool> updateTask(String inquiryId, String taskId, String priorityId,
      String description, String userId, List<String> fileNames) async {
    try {
      final headers = {
        "dtype": "TASK",
        "inqrid": inquiryId,
        "taskid": taskId,
        "inqrdesc": description,
        "userid": userId,
        "priorityid": priorityId,
        "files": fileNames.length,
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
          //contentType: MediaType("image", "jpeg"),
        ),
      ));
    }

    debugPrint("FORM DATA: ${formData.fields}");

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


  Future<List<Map<String, dynamic>>> saveImages2(
      List<Uint8List> files,
      List<String> paths,
      String invoiceId,
      String dbId,
      ) async {
    final formData = FormData();

    // Add additional form fields
    formData.fields.addAll([
      MapEntry('challanno', invoiceId),
      MapEntry('dbid', dbId),
    ]);

    // Add files to form data
    for (int i = 0; i < files.length; i++) {
      formData.files.add(MapEntry(
        'files', // key expected by the server
        MultipartFile.fromBytes(
          files[i],
          filename: paths[i], // make sure filenames are unique and valid
        ),
      ));
    }

    debugPrint("FORM DATA: ${formData.fields}");

    try {
      /*final response = await APIService.instance.request(
        "ImageUpload/upload",
        DioMethod.post,
        null,
        null,
        formData,
      );*/
      final response = await fileDio.post("ImageUpload/upload", data: formData);

      // Check for success
      if (response.statusCode == 200) {
        final data = response.data;

        // Handle success case where response is a list
        if (data is List) {
          return data.map((item) => Map<String, dynamic>.from(item)).toList();
        }

        // Handle failure message in response as map
        else if (data is Map && data['status'] == 'N') {
          final errorMsg = data['FileName'] ?? 'Unknown error';
          throw Exception('Server error: $errorMsg');
        }

        // Unknown format fallback
        else {
          throw Exception('Unexpected response format: $data');
        }
      } else {
        throw Exception('API failed with status code: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('❌ Upload failed: $e');
      throw Exception("Upload failed: ${e.toString()}");
    }
  }


  Future<List<InquiryResponse>> getInquiries(
      String flag, String userId, String isAssigned, String vm) async {
    try {
      final headers = {
        'vm': vm,
        'va': flag,
        'vb': userId,
        'vc': isAssigned,
        'vd': 'queries',
      };
      final response = await dio.get(
        "getall",
        options: Options(headers: headers),
      );
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

  Future<List<Note>> getNotes(String inquiryId, String taskId) async {
    try {
      final headers = {
        'vm': 'COMMENTS_TASK',
        'va': inquiryId,
        'vb': taskId,
        'vc': 'XX',
        'vd': 'notes',
      };

      final response = await dio.get(
        "getall",
        options: Options(headers: headers),
      );

      // Check if the response contains valid 'notes' data
      if (response.data is Map<String, dynamic> &&
          response.data.containsKey('notes')) {
        final List<dynamic> notesJson = response.data['notes'] ?? [];
        return notesJson.map((json) => Note.fromJson(json)).toList();
      } else {
        return []; // Return an empty list if no notes found
      }
    } on DioException catch (error) {
      debugPrint("Error fetching notes: ${error.message}");
      throw Exception(
          "Failed to fetch notes: ${error.response?.statusMessage}");
    }
  }

  Future<List<StringUrl>> getAttachments(
      String inquiryId, String taskId) async {
    try {
      final headers = {
        'vm': 'ATTACHMENT_TASK',
        'va': inquiryId,
        'vb': taskId,
        'vc': 'XX',
        'vd': 'attachments',
      };

      final response = await dio.get(
        "getall",
        options: Options(headers: headers),
      );

      // Check if the response contains valid 'notes' data
      if (response.data is Map<String, dynamic> &&
          response.data.containsKey('attachments')) {
        final List<dynamic> notesJson = response.data['attachments'] ?? [];
        return notesJson.map((json) => StringUrl.fromJson(json)).toList();
      } else {
        return []; // Return an empty list if no notes found
      }
    } on DioException catch (error) {
      debugPrint("Error fetching notes: ${error.message}");
      throw Exception(
          "Failed to fetch notes: ${error.response?.statusMessage}");
    }
  }

  Future<List<Discussion>> getComments(String inquiryId, String taskId) async {
    try {
      final headers = {
        'vm': 'COMMENTS',
        'va': inquiryId,
        'vb': taskId,
        'vc': 'XX',
        'vd': 'comments',
      };

      final response = await dio.get(
        "getall",
        options: Options(headers: headers),
      );

      // Check if the response contains valid 'notes' data
      if (response.data is Map<String, dynamic> &&
          response.data.containsKey('comments')) {
        final List<dynamic> notesJson = response.data['comments'] ?? [];
        return notesJson.map((json) => Discussion.fromJson(json)).toList();
      } else {
        return []; // Return an empty list if no notes found
      }
    } on DioException catch (error) {
      debugPrint("Error fetching notes: ${error.message}");
      throw Exception(
          "Failed to fetch notes: ${error.response?.statusMessage}");
    }
  }

  Future<bool> saveComment(
      String inquiryId, String body, String priorityId, String userId) async {
    try {
      final headers = {
        "dtype": "TASK",
        "inqrid": inquiryId,
        "inqrdesc": body,
        "taskid": "0",
        "userid": userId,
        "priorityid": "0",
        "files": "0",
      };

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

  Future<StaffResponse> getStaffs(String staffId, String companyId, String vm) async {
    try {
      final headers = {
        'vm': vm,
        'va': companyId,
        'vb': staffId,
        'vc': '0',
        'vd': 'staffs',
      };
      final response = await dio.get(
        "getall",
        options: Options(headers: headers),
      );
      debugPrint("RESPONSE#${response.data}");
      return StaffResponse.fromJson(response.data);
    } on DioException catch (error) {
      throw Exception(error);
    }
  }

  Future<String> getCount(String staffId, String flag) async {
    try {
      final headers = {
        'vm': 'COUNTER',
        'va': flag,
        'vb': staffId,
        'vc': '0',
        'vd': 'count',
      };
      final response = await dio.get(
        "getall",
        options: Options(headers: headers),
      );
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

  /// DEMO API

  /*Future<List<InquiryResponse>> getInquiries() async {
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
  }*/

  /*Future<String> getCount() async {
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
  }*/

/*Future<AttachmentViewResponse> getAttachments() async {
    try {
      final response = await dio.get("5dedf78a78969c55cfb3");
      debugPrint("RESPONSE#${response.data}");
      return AttachmentViewResponse.fromJson(response.data);
    } on DioException catch (error) {
      throw Exception(error);
    }
  }*/

/*Future<NoteResponse> getNotes() async {
    try {
      final response = await dio.get("2a2ecc5de4a852629548");
      debugPrint("RESPONSE#${response.data}");
      return NoteResponse.fromJson(response.data);
    } on DioException catch (error) {
      throw Exception(error);
    }
  }*/

/*Future<CommentResponse> getComments() async {
    try {
      final response = await dio.get("c129b21084d6208d2753");
      debugPrint("RESPONSE#${response.data}");
      return CommentResponse.fromJson(response.data);
    } on DioException catch (error) {
      throw Exception(error);
    }
  }*/
}
