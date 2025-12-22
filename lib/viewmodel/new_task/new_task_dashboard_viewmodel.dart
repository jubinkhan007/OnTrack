import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:tmbi/config/enum.dart';
import 'package:tmbi/config/extension_file.dart';
import 'package:tmbi/db/dao/sync_dao.dart';
import 'package:tmbi/models/new_task/bu_response.dart';
import 'package:tmbi/models/new_task/task_response.dart';
import 'package:tmbi/repo/new_task/new_task_dashboard_repo.dart';

import '../../network/ui_state.dart';

class NewTaskDashboardViewmodel extends ChangeNotifier {
  final NewTaskDashboardRepo ntdRepo;
  final String staffId;

  NewTaskDashboardViewmodel({required this.staffId, required this.ntdRepo}) {
      getBUStaffs();
    //getTasks();
  }

  String _pending = "0";
  String _overdue = "0";
  String _completed = "0";

  List<Task> _tasks = [];

  List<BusinessUnit> _buStaffs = [];

  List<Task> get tasks => _tasks;

  List<BusinessUnit> get buStaffs => _buStaffs;

  String get pending => _pending;

  String get overdue => _overdue;

  String get completed => _completed;

  bool? _isDeleted;

  bool? get isDeleted => _isDeleted;

  bool? _isTaskDeleted;

  bool? get isTaskDeleted => _isTaskDeleted;

  int selectedTab = 0; // 0=Created, 1=Assigned
  //TaskStatusFlag statusTab = TaskStatusFlag.all;
  TaskStatusFlag statusTab = TaskStatusFlag.pending;

  void changeTab(int index) {
    selectedTab = index;
    resetBuStaff();
    getTasks();
    notifyListeners();
  }

  void changeStatus(TaskStatusFlag status) {
    statusTab = status;
    getTasks();
    notifyListeners();
  }

  // bu search
  CompInfo? selectedBU;
  final Set<String> buOptions = {};
  final List<CompInfo> compInfoList = [];
  String buStaffId = "";

  void changeBU(CompInfo? ci) {
    selectedBU = ci;
    getTasks();
    notifyListeners();
  }

  void changeStaff(String staffId) {
    buStaffId = staffId;
    getTasks();
    notifyListeners();
  }

  Future<void> getBUStaffs() async {
    if (!await isEmailUser()) {
      final syncDao = SyncDao();
      if (_buStaffs.isNotEmpty) {
        _buStaffs.clear();
      }
      _buStaffs = await syncDao.getAllStaffs();
      await getCompInfoList();
      await getTasks();
      notifyListeners();
    }
  }

  /*Future<void> getCompInfoList() async {
    for (var item in _buStaffs) {
      if (buOptions.add(item.compId)) {
        compInfoList.add(
          CompInfo(
            compId: item.compId,
            name: item.compName,
          ),
        );
      }
    }
    //notifyListeners();
  }*/

  Future<void> getCompInfoList() async {
    // Add the initial "All" option **once**
    compInfoList.add(CompInfo(
      compId: "999",
      name: "All",
    ));
    // Clear the set that tracks duplicates if needed
    buOptions.clear();
    // Add items from _buStaffs without duplicates
    for (var item in _buStaffs) {
      if (buOptions.add(item.compId)) {
        compInfoList.add(
          CompInfo(
            compId: item.compId,
            name: item.compName,
          ),
        );
      }
    }
    selectedBU = compInfoList.first;
    debugPrint("BU::${selectedBU!.name} & ${selectedBU!.compId}");
    // notifyListeners();
  }

  TextEditingController staffController = TextEditingController();

  String get staffName => staffController.text;

  void setStaffName(String name) {
    staffController.text = name;
    notifyListeners();
  }

  void clearStaff() {
    staffController.clear();
    notifyListeners();
  }

  void resetBuStaff() {
    buStaffId = "";
    selectedBU = compInfoList.first;
    setStaffName("");
    clearStaff();
  }

  void reset() {
    buStaffId = "";
    selectedBU = compInfoList.first;
    selectedTab = 0;
    statusTab = TaskStatusFlag.pending;
    setStaffName("");
    clearStaff();
  }

  Future<bool> isEmailUser() async {
    if (staffId.isEmail()) {
      buStaffId = "";
      selectedBU = CompInfo(compId: "999", name: "All");
      selectedTab = 1;
      statusTab = TaskStatusFlag.pending;
      setStaffName("");
      clearStaff();
      await getTasks();
      return true;
    }
    return false;
  }

  // --- API --- \\
  String? _message;

  String? get message => _message;

  TaskDataModel? _taskResponse;

  TaskDataModel? get buResponse => _taskResponse;

  // UI state
  UiState _uiState = UiState.init;

  UiState get uiState => _uiState;

  set uiState(UiState newState) {
    if (_uiState != newState) {
      // only notify if the state has actually changed
      _uiState = newState;
      notifyListeners();
    }
  }

  Future<void> getTasks() async {
    if (_uiState == UiState.loading) return;

    _uiState = UiState.loading;
    notifyListeners();

    try {
      final response = await ntdRepo.getTasks(
        staffId,
        selectedBU != null ? selectedBU!.compId : "0",
        selectedTab.toString(),
        buStaffId.isEmpty ? "0" : buStaffId,
        statusTab.getData.second,
      );

      _taskResponse = response;

      // clear previous data
      _tasks.clear();
      _pending = "0";
      _overdue = "0";
      _completed = "0";

      if (_taskResponse != null && _taskResponse!.data.isNotEmpty) {
        final data = _taskResponse!.data[0];

        _pending = data.pending.toString();
        _overdue = data.overdue.toString();
        _completed = data.completed.toString();

        if (data.tasks.isNotEmpty) {
          _tasks.addAll(data.tasks);
        } else {
          _message = "(no data found)";
        }

        _uiState = UiState.success;
      } else {
        _message = "(no data found)";
        _uiState = UiState.success; // still success, just empty
      }
    } catch (e) {
      _message = e.toString();
      _uiState = UiState.error;
    } finally {
      notifyListeners();
    }
  }

  Future<void> deleteAccount(String userId, String password) async {
    if (_uiState == UiState.loading) return;

    _uiState = UiState.loading;
    _message = null;
    notifyListeners();
    try {
      final response = await ntdRepo.deleteAccount(userId, password, []);
      _isDeleted = response;
      _uiState = UiState.success;
    } catch (error) {
      _uiState = UiState.error;
      _message = error.toString();
    } finally {
      notifyListeners();
    }
  }

  Future<void> deleteTask(
      String inquiryId) async {
    if (_uiState == UiState.loading) return;

    _uiState = UiState.loading;
    notifyListeners();
    try {
      final response =
      await ntdRepo.deleteTask(inquiryId);
      _isTaskDeleted = response;
      _uiState = UiState.success;
      if (response) {
        getTasks();
      }
    } catch (error) {
      _uiState = UiState.error;
      _message = error.toString();
    } finally {
      notifyListeners();
    }
  }

}
