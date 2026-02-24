import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:tmbi/models/new_task/report_response.dart';

class ReportRepo {
  final Dio dio;

  ReportRepo({required this.dio});

  Future<List<DeptWiseStatus>> getDeptReport({
    required String staffId,
    required String compId,
    required String groupId,
    required String deptId,
    required String subDeptId,
    required String tnaTypeId,
  }) async {
    try {
      final headers = {
        'vm': 'DEPT_STATUS',
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
      return _parseList(response.data, DeptWiseStatus.fromJson);
    } on DioException catch (error) {
      debugPrint('Dio Exception (getDeptReport): ${error.message}');
      debugPrint('Response Data: ${error.response?.data}');
      rethrow;
    } catch (e) {
      debugPrint('General error (getDeptReport): $e');
      throw Exception('Unknown error occurred: $e');
    }
  }

  Future<List<CompanyWiseStatus>> getCompanyReport({
    required String staffId,
    required String compId,
    required String groupId,
    required String deptId,
    required String subDeptId,
    required String tnaTypeId,
  }) async {
    try {
      final headers = {
        'vm': 'COMPANY_STATUS',
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
      return _parseList(response.data, CompanyWiseStatus.fromJson);
    } on DioException catch (error) {
      debugPrint('Dio Exception (getCompanyReport): ${error.message}');
      debugPrint('Response Data: ${error.response?.data}');
      rethrow;
    } catch (e) {
      debugPrint('General error (getCompanyReport): $e');
      throw Exception('Unknown error occurred: $e');
    }
  }

  Future<List<UserWiseStatus>> getUserReport({
    required String staffId,
    required String compId,
    required String groupId,
    required String deptId,
    required String subDeptId,
    required String tnaTypeId,
  }) async {
    try {
      final headers = {
        'vm': 'USER_STATUS',
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
      return _parseList(response.data, UserWiseStatus.fromJson);
    } on DioException catch (error) {
      debugPrint('Dio Exception (getUserReport): ${error.message}');
      debugPrint('Response Data: ${error.response?.data}');
      rethrow;
    } catch (e) {
      debugPrint('General error (getUserReport): $e');
      throw Exception('Unknown error occurred: $e');
    }
  }

  Future<ReportFilters> getReportFilters({
    required String staffId,
    required String compId,
  }) async {
    try {
      final headers = {
        'vm': 'GET_REPORT_FILTERS',
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

List<T> _parseList<T>(
  dynamic data,
  T Function(Map<String, dynamic>) fromJson,
) {
  if (data is List) {
    return data.map((e) => fromJson(e as Map<String, dynamic>)).toList();
  } else if (data is Map<String, dynamic>) {
    // Backend wraps the list under a numeric string key e.g. {"0": [...]}
    final listValue = data.values.firstWhere(
      (v) => v is List,
      orElse: () => <dynamic>[],
    );
    return (listValue as List)
        .map((e) => fromJson(e as Map<String, dynamic>))
        .toList();
  }
  return [];
}
