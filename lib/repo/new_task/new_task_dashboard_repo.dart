import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:tmbi/models/new_task/task_response.dart';
import 'package:tmbi/network/http_header_sanitizer.dart';
import 'package:tmbi/network/network_debug_logger.dart';

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
      if (kDebugMode) {
        try {
          final data = response.data;
          if (data is Map && data['Data'] is List) {
            final dataList = data['Data'] as List;
            for (var i = 0; i < dataList.length; i++) {
              final item = dataList[i];
              if (item is Map) {
                final tasks = item['TASKS'];
                final taskCount = tasks is List ? tasks.length : '?';
                debugPrint(
                  '[getTasks] va=$buId vc=$isCreatedByMe ve=$status → '
                  'PENNDING=${item['PENNDING']} OVERDUE=${item['OVERDUE']} '
                  'COMPLETED=${item['COMPLETED']} TASKS=$taskCount',
                );
              }
            }
          }
        } catch (_) {}
      }
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
      final safeTitle = HttpHeaderSanitizer.sanitize(title);
      final safeDetails = HttpHeaderSanitizer.sanitize(details);
      final safeAssignees = HttpHeaderSanitizer.sanitize(assignees);

      Future<Response<dynamic>> postWithHeaders(Map<String, dynamic> headers) {
        return dio.post(
          "saveall",
          options: Options(headers: headers),
        );
      }

      final headers = {
        "dtype": "INQUERY",
        "compid": companyId,
        "custid": customerId,
        "inqrid": inquiryId,
        "inqrname": safeTitle,
        "inqrdesc": safeDetails,
        "salmpleflag": isSample,
        "needdate": dueDate,
        "startdate": startDate ?? dueDate,
        "userid": userId,
        "custname": customerName,
        "priorityid": priorityId,
        "taskdetail": safeAssignees,
        "files": "0"
      };
      NetworkDebugLogger.logSaveTaskDiagnostics(
        title: safeTitle,
        details: safeDetails,
        dueDate: dueDate,
        startDate: startDate,
        assignees: safeAssignees,
        headers: headers,
      );

      final response = await postWithHeaders(headers);
      dynamic status = response.data is Map ? response.data['status'] : null;
      final statusStr = status?.toString() ?? "";
      debugPrint('[saveTask] status=$status (${status.runtimeType})');
      if (statusStr == "200") return true;

      return false;
    } on DioException catch (error) {
      debugPrint("RESPONSE_ERROR#$error");
      rethrow;
    }
  }
}
