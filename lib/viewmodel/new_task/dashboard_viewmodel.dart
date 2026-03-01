import 'package:flutter/material.dart';
import 'package:tmbi/models/new_task/dashboard_response.dart';
import 'package:tmbi/network/ui_state.dart';
import 'package:tmbi/repo/new_task/dashboard_repo.dart';

class DashboardViewmodel extends ChangeNotifier {
  final String staffId;
  final DashboardRepo dashboardRepo;

  DashboardViewmodel({required this.staffId, required this.dashboardRepo}) {
    _selectedCompId = '0';
    loadFilters();
    loadDashboard();
  }

  UiState _uiState = UiState.loading;
  UiState get uiState => _uiState;

  bool _filtersLoading = false;
  bool get filtersLoading => _filtersLoading;

  // Raw (unfiltered) data from the server
  List<DeptWiseStatus> _rawDeptData = [];
  List<CompanyWiseStatus> _rawCompanyData = [];
  List<UserWiseStatus> _rawUserData = [];

  // Frontend-filtered getters
  List<DeptWiseStatus> get deptData {
    if (_selectedDeptId == '0') return _rawDeptData;
    final opt = _filterOptions.depts.firstWhere(
      (o) => o.id == _selectedDeptId,
      orElse: () => DashboardFilterOption(id: '0', name: ''),
    );
    if (opt.name.isEmpty) return _rawDeptData;
    return _rawDeptData.where((d) => d.deptName == opt.name).toList();
  }

  List<CompanyWiseStatus> get companyData {
    if (_selectedCompId == '0') return _rawCompanyData;
    final opt = _filterOptions.companies.firstWhere(
      (o) => o.id == _selectedCompId,
      orElse: () => DashboardFilterOption(id: '0', name: ''),
    );
    if (opt.name.isEmpty) return _rawCompanyData;
    return _rawCompanyData.where((c) => c.companyName == opt.name).toList();
  }

  List<UserWiseStatus> get userData => _rawUserData;

  DashboardFilters _filterOptions = DashboardFilters.empty();
  DashboardFilters get filterOptions => _filterOptions;

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

  Future<void> loadDashboard() async {
    _uiState = UiState.loading;
    notifyListeners();

    try {
      final deptFuture = dashboardRepo.getDeptDashboard(
        staffId: staffId,
        compId: _selectedCompId,
        groupId: _selectedGroupId,
        deptId: _selectedDeptId,
        subDeptId: _selectedSubDeptId,
        tnaTypeId: _selectedTnaTypeId,
      );
      final companyFuture = dashboardRepo.getCompanyDashboard(
        staffId: staffId,
        compId: _selectedCompId,
        groupId: _selectedGroupId,
        deptId: _selectedDeptId,
        subDeptId: _selectedSubDeptId,
        tnaTypeId: _selectedTnaTypeId,
      );
      final userFuture = dashboardRepo.getUserDashboard(
        staffId: staffId,
        compId: _selectedCompId,
        groupId: _selectedGroupId,
        deptId: _selectedDeptId,
        subDeptId: _selectedSubDeptId,
        tnaTypeId: _selectedTnaTypeId,
      );

      _rawDeptData = await deptFuture;
      _rawCompanyData = await companyFuture;
      _rawUserData = await userFuture;
      _uiState = UiState.success;
    } catch (e) {
      _errorMessage = e.toString();
      _uiState = UiState.error;
    }

    notifyListeners();
  }

  Future<void> loadFilters() async {
    if (_filtersLoading) return;
    _filtersLoading = true;
    notifyListeners();
    try {
      _filterOptions = await dashboardRepo.getDashboardFilters(
        staffId: staffId,
        compId: _selectedCompId,
        groupId: _selectedGroupId,
        deptId: _selectedDeptId,
      );
    } catch (e) {
      debugPrint('[DashboardViewmodel] loadFilters error: $e');
    } finally {
      _filtersLoading = false;
      notifyListeners();
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
      _selectedGroupId = '0';
      _selectedDeptId = '0';
      _selectedSubDeptId = '0';
      _selectedTnaTypeId = '0';
      _filterOptions = _filterOptions.copyWith(
        groups: const [],
        depts: const [],
        subDepts: const [],
        tnaTypes: const [],
      );
      changed = true;
      loadFilters();
    }
    if (groupId != null && groupId != _selectedGroupId) {
      _selectedGroupId = groupId;
      _selectedDeptId = '0';
      _selectedSubDeptId = '0';
      _selectedTnaTypeId = '0';
      _filterOptions = _filterOptions.copyWith(
        depts: const [],
        subDepts: const [],
        tnaTypes: const [],
      );
      changed = true;
      loadFilters();
    }
    if (deptId != null && deptId != _selectedDeptId) {
      _selectedDeptId = deptId;
      _selectedSubDeptId = '0';
      _selectedTnaTypeId = '0';
      _filterOptions = _filterOptions.copyWith(
        subDepts: const [],
        tnaTypes: const [],
      );
      changed = true;
      loadFilters();
    }
    if (subDeptId != null && subDeptId != _selectedSubDeptId) {
      _selectedSubDeptId = subDeptId;
      changed = true;
    }
    if (tnaTypeId != null && tnaTypeId != _selectedTnaTypeId) {
      _selectedTnaTypeId = tnaTypeId;
      changed = true;
    }

    // Filtering is done on the frontend — no re-fetch needed, just re-render.
    if (changed) {
      notifyListeners();
    }
  }

  void resetFilters() {
    _selectedCompId = '0';
    _selectedGroupId = '0';
    _selectedDeptId = '0';
    _selectedSubDeptId = '0';
    _selectedTnaTypeId = '0';
    _filterOptions = DashboardFilters.empty();
    loadFilters();
    notifyListeners();
  }
}
