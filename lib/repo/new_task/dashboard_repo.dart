import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:tmbi/models/new_task/dashboard_response.dart';

class DashboardRepo {
  final Dio dio;

  DashboardRepo({required this.dio});

  Future<List<DeptWiseStatus>> getDeptDashboard({
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
      debugPrint('Dio Exception (getDeptDashboard): ${error.message}');
      debugPrint('Response Data: ${error.response?.data}');
      rethrow;
    } catch (e) {
      debugPrint('General error (getDeptDashboard): $e');
      throw Exception('Unknown error occurred: $e');
    }
  }

  Future<List<CompanyWiseStatus>> getCompanyDashboard({
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
      debugPrint('Dio Exception (getCompanyDashboard): ${error.message}');
      debugPrint('Response Data: ${error.response?.data}');
      rethrow;
    } catch (e) {
      debugPrint('General error (getCompanyDashboard): $e');
      throw Exception('Unknown error occurred: $e');
    }
  }

  Future<List<UserWiseStatus>> getUserDashboard({
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
      debugPrint('Dio Exception (getUserDashboard): ${error.message}');
      debugPrint('Response Data: ${error.response?.data}');
      rethrow;
    } catch (e) {
      debugPrint('General error (getUserDashboard): $e');
      throw Exception('Unknown error occurred: $e');
    }
  }

  Future<DashboardFilters> getDashboardFilters({
    required String staffId,
    required String compId,
    required String groupId,
    required String deptId,
  }) async {
    String _pickString(
      Map<String, dynamic> json,
      List<String> keys, {
      required String fallback,
    }) {
      for (final k in keys) {
        final v = json[k];
        if (v != null) return v.toString().trim();
      }
      return fallback;
    }

    Future<List<DashboardFilterOption>> safeFetch(
      String vm,
      String idKey,
      String nameKey, {
      String vc = '0',
      String vd = '0',
      String ve = '0',
      String vf = '0',
      String? vbOverride,
    }) async {
      try {
        final response = await dio.get(
          'getall',
          options: Options(
            headers: {
              'vm': vm,
              'va': staffId,
              'vb': vbOverride ?? compId,
              'vc': vc,
              'vd': vd,
              've': ve,
              'vf': vf,
            },
          ),
        );
        return _parseList(
          response.data,
          (json) => DashboardFilterOption(
            id: _pickString(json, [idKey, 'R', 'ID'], fallback: '0'),
            name: _pickString(json, [nameKey, 'D', 'NAME'], fallback: ''),
          ),
        );
      } catch (e) {
        debugPrint('[DashboardRepo] $vm failed: $e');
        return [];
      }
    }

    // Company list should remain available even after selecting a company.
    final compsFuture = safeFetch('FILTER_COM', 'R', 'D', vbOverride: '0');
    final groupsFuture = safeFetch('FILTER_GROUP', 'R', 'D');
    final deptsFuture = safeFetch('FILTER_DEPT', 'DEPT_ID', 'D', vc: groupId);

    final shouldLoadDependent = deptId != '0';
    final subDeptsFuture = shouldLoadDependent
        ? safeFetch('FILTER_SUB_DEPT', 'R', 'D', vc: groupId, vd: deptId)
        : Future.value(<DashboardFilterOption>[]);
    final tnaFuture = shouldLoadDependent
        ? safeFetch('FILTER_TNA_TYPE', 'R', 'D', vc: groupId, vd: deptId)
        : Future.value(<DashboardFilterOption>[]);

    return DashboardFilters(
      companies: await compsFuture,
      groups: await groupsFuture,
      depts: await deptsFuture,
      subDepts: await subDeptsFuture,
      tnaTypes: await tnaFuture,
    );
  }
}

List<T> _parseList<T>(dynamic data, T Function(Map<String, dynamic>) fromJson) {
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
