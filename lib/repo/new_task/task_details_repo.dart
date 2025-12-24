

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:tmbi/models/new_task/main_task_response.dart';

class TaskDetailsRepo {
  final Dio dio;

  TaskDetailsRepo({required this.dio});

  Future<MainTaskResponse> getSubTasks(String staffId, String taskId) async {
    try {
      final headers = {
        'vm': 'TASK_DETAIL',
        'va': taskId,
        'vb': staffId,
        'vc': '0',
        'vd': 'DATA',
      };
      final response = await dio.get(
        "getall",
        options: Options(headers: headers),
      );
      debugPrint("RESPONSE#${response.data}");
      final parsed = MainTaskResponse.fromJson(response.data);
      return parsed;
    } on DioException catch (error) {
      throw Exception(error);
    }
  }

  Future<bool> updateTask(String inquiryId, String taskId, String priorityId,
      String description, String userId, String percentage, List<String> fileNames) async {
    try {
      final headers = {
        "dtype": "TASK",
        "inqrid": inquiryId,
        "taskid": taskId,
        "inqrdesc": description,
        "userid": userId,
        "priorityid": priorityId,
        "percentage_value": percentage,
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


}