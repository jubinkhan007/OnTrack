import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:tmbi/models/new_task/task_response.dart';

class NewTaskDashboardRepo {
  final Dio dio;

  NewTaskDashboardRepo({required this.dio});

  Future<TaskDataModel> getTasks(
      String staffId,
      String buId,
      String isCreatedByMe,
      String buStaffId,
      String status,
      ) async {
    try {
      // Setting up headers
      final headers = {
        'vm': 'GET_TASKS',
        //'va': buId, // bu_id
        'va': buId, // bu_id
        'vb': staffId,
        'vc': isCreatedByMe, // is_created_by_me
        'vd': 'Data', // bu_staff_id
        've': status // status
      };

      // Making the GET request
      final response = await dio.get(
        "getall",
        options: Options(headers: headers),
      );
      //debugPrint("RESPONSE# ${response.data}");
      return TaskDataModel.fromJson(response.data);
    } on DioException catch (error) {
      debugPrint('Dio Exception: ${error.message}');
      debugPrint('Response Data: ${error.response?.data}');
      throw Exception('Error occurred while fetching tasks: ${error.message}');
    } catch (e) {
      debugPrint('General error: $e');
      throw Exception('Unknown error occurred: $e');
    }
  }


}
