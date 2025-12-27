import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:tmbi/models/new_task/main_task_response.dart';

import '../../models/new_task/comment_response.dart';

class CommentRepo {
  final Dio dio;

  CommentRepo({required this.dio});

  Future<List<Comment>> getComments(
    String staffId,
    String inqId,
    SubTask? subTask,
  ) async {
    try {
      final headers = {
        'vm': subTask != null ? "COMMENTS_TASK" : 'COMMENTS',
        'va': inqId,
        'vb': subTask != null ? subTask.id : inqId,
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

  Future<bool> saveComment(
      String inquiryId, String body, String userId, SubTask? subTask) async {
    try {
      final headers = {
        "dtype": "TASK",
        "inqrid": inquiryId,
        "inqrdesc": body,
        "taskid": subTask == null ? "0" : subTask.id,
        "userid": userId,
        "priorityid": subTask == null
            ? "0"
            : subTask.completion == "100"
                ? "7"
                : "3",
        "percentage_value": subTask == null ? "0" : subTask.completion,
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
