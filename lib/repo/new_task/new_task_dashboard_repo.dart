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
        'vd': 'Data',
        've': status, // status
        'vf': buStaffId
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
      rethrow;
    } catch (e) {
      debugPrint('General error: $e');
      throw Exception('Unknown error occurred: $e');
    }
  }

  Future<bool> deleteAccount(
      String userId, String password, List<String> fileNames) async {
    try {
      final headers = {
        "dtype": "DELETE_ACCOUNT",
        "inqrid": "0",
        "taskid": "0",
        "inqrdesc": password,
        "userid": userId,
        "priorityid": "0",
        "percentage_value": "0",
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

  Future<bool> deleteTask(String inquiryId) async {
    try {
      final headers = {
        "dtype": "DELETE",
        "inqrid": inquiryId,
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

  Future<bool> saveTask(
      {String companyId = "0",
      String inquiryId = "0",
      String customerId = "0",
      String customerName = "Other",
      String isSample = "N",
      required String title,
      required String details,
      required String dueDate,
      String? startDate,
      required String priorityId,
      required String userId,
      required String assignees}) async {
    try {
      final headers = {
        "dtype": "INQUERY",
        "compid": companyId,
        "custid": customerId,
        "inqrid": inquiryId,
        "inqrname": title,
        "inqrdesc": details,
        "salmpleflag": isSample,
        "needdate": dueDate,
        "startdate": startDate ?? dueDate,
        "userid": userId,
        "custname": customerName,
        "priorityid": priorityId,
        "taskdetail": assignees,
        "files": "0"
      };
      final response = await dio.post(
        "saveall",
        options: Options(headers: headers),
      );
      debugPrint("RESPONSE#${response.data}");
      return response.data['status'] == "200";
    } on DioException catch (error) {
      debugPrint("RESPONSE_ERROR#$error");
      rethrow;
    }
  }
}
