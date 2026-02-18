import 'package:flutter/material.dart';
import 'package:tmbi/models/new_task/bu_response.dart';
import 'package:tmbi/models/new_task/report_response.dart';
import 'package:tmbi/network/ui_state.dart';
import 'package:tmbi/repo/new_task/report_repo.dart';

class ReportViewmodel extends ChangeNotifier {
  final String staffId;
  final List<CompInfo> companyList;
  final ReportRepo reportRepo;

  ReportViewmodel({
    required this.staffId,
    required this.companyList,
    required this.reportRepo,
  }) {
    _selectedCompId = '0';
    loadFilters();
    loadReport();
  }

  UiState _uiState = UiState.loading;
  UiState get uiState => _uiState;

  ReportData _reportData = ReportData.empty();
  ReportData get reportData => _reportData;

  ReportFilters _filterOptions = ReportFilters.empty();
  ReportFilters get filterOptions => _filterOptions;

  String _selectedCompId = '0';
  String get selectedCompId => _selectedCompId;

  String _selectedGroupId = '0';
  String get selectedGroupId => _selectedGroupId;

  String _selectedDeptId = '0';
  String get selectedDeptId => _selectedDeptId;

  String _selectedSubDeptId = '0';
  String get selectedSubDeptId => _selectedSubDeptId;

  String _selectedTnaTypeId = '0';
  String get selectedTnaTypeId => _selectedTnaTypeId;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  Future<void> loadReport() async {
    _uiState = UiState.loading;
    notifyListeners();

    try {
      _reportData = await reportRepo.getReport(
        staffId: staffId,
        compId: _selectedCompId,
        groupId: _selectedGroupId,
        deptId: _selectedDeptId,
        subDeptId: _selectedSubDeptId,
        tnaTypeId: _selectedTnaTypeId,
      );
      _uiState = UiState.success;
    } catch (e) {
      _errorMessage = e.toString();
      _uiState = UiState.error;
    }

    notifyListeners();
  }

  Future<void> loadFilters() async {
    try {
      _filterOptions = await reportRepo.getReportFilters(
        staffId: staffId,
        compId: _selectedCompId,
      );
      notifyListeners();
    } catch (_) {
      // filters are non-critical; silently ignore
    }
  }

  void onFilterChanged({
    String? compId,
    String? groupId,
    String? deptId,
    String? subDeptId,
    String? tnaTypeId,
  }) {
    bool changed = false;

    if (compId != null && compId != _selectedCompId) {
      _selectedCompId = compId;
      changed = true;
      // reload filters when company changes
      loadFilters();
    }
    if (groupId != null && groupId != _selectedGroupId) {
      _selectedGroupId = groupId;
      changed = true;
    }
    if (deptId != null && deptId != _selectedDeptId) {
      _selectedDeptId = deptId;
      changed = true;
    }
    if (subDeptId != null && subDeptId != _selectedSubDeptId) {
      _selectedSubDeptId = subDeptId;
      changed = true;
    }
    if (tnaTypeId != null && tnaTypeId != _selectedTnaTypeId) {
      _selectedTnaTypeId = tnaTypeId;
      changed = true;
    }

    if (changed) {
      loadReport();
    }
  }

  void resetFilters() {
    _selectedCompId = '0';
    _selectedGroupId = '0';
    _selectedDeptId = '0';
    _selectedSubDeptId = '0';
    _selectedTnaTypeId = '0';
    loadFilters();
    loadReport();
  }
}
