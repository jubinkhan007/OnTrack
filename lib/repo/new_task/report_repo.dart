import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:tmbi/models/new_task/report_response.dart';

class ReportRepo {
  final Dio dio;

  ReportRepo({required this.dio});

  Future<ReportData> getReport({
    required String staffId,
    required String compId,
    required String groupId,
    required String deptId,
    required String subDeptId,
    required String tnaTypeId,
  }) async {
    try {
      final headers = {
        'vm': 'GET_REPORT', // TODO: backend to confirm exact value
        'va': staffId,
        'vb': compId,
        'vc': groupId,
        'vd': deptId,
        've': subDeptId,
        'vf': tnaTypeId,
      };

      final response = await dio.get(
        'getall',
        options: Options(headers: headers),
      );
      return ReportData.fromJson(response.data);
    } on DioException catch (error) {
      debugPrint('Dio Exception (getReport): ${error.message}');
      debugPrint('Response Data: ${error.response?.data}');
      rethrow;
    } catch (e) {
      debugPrint('General error (getReport): $e');
      throw Exception('Unknown error occurred: $e');
    }
  }

  Future<ReportFilters> getReportFilters({
    required String staffId,
    required String compId,
  }) async {
    try {
      final headers = {
        'vm': 'GET_REPORT_FILTERS', // TODO: backend to confirm exact value
        'va': staffId,
        'vb': compId,
      };

      final response = await dio.get(
        'getall',
        options: Options(headers: headers),
      );
      return ReportFilters.fromJson(response.data);
    } on DioException catch (error) {
      debugPrint('Dio Exception (getReportFilters): ${error.message}');
      debugPrint('Response Data: ${error.response?.data}');
      rethrow;
    } catch (e) {
      debugPrint('General error (getReportFilters): $e');
      throw Exception('Unknown error occurred: $e');
    }
  }
}
