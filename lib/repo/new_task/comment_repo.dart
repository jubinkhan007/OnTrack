import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

import '../../models/new_task/comment_response.dart';

class CommentRepo {
  final Dio dio;

  CommentRepo({required this.dio});

  Future<List<Comment>> getComments(
    String staffId,
    String inqId,
    String taskId,
  ) async {
    try {
      final headers = {
        'vm': 'COMMENTS',
        'va': inqId,
        'vb': taskId,
        'vc': staffId,
        'vd': 'comments'
      };

      final response = await dio.get(
        "getall",
        options: Options(headers: headers),
      );

      if (response.data is Map<String, dynamic> &&
          response.data['comments'] != null) {
        return (response.data['comments'] as List)
            .map((e) => Comment.fromJson(e))
            .toList();
      }
      return []; // no comments
    } on DioException catch (error) {
      debugPrint("Error fetching comments: ${error.message}");
      throw Exception(
        "Failed to fetch comments: ${error.response?.statusMessage}",
      );
    }
  }

  Future<bool> saveComment(String inquiryId, String body, String userId) async {
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
}
