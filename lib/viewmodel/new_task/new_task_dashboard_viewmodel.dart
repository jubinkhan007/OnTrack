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
    getTasks();
    getBUStaffs();
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
    final syncDao = SyncDao();
    if (_buStaffs.isNotEmpty) {
      _buStaffs.clear();
    }
    _buStaffs = await syncDao.getAllStaffs();
    await getCompInfoList();
    notifyListeners();
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
    compInfoList.add(
      CompInfo(
        compId: "0",
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
    //if (_disposed) {
    //return; // Do nothing if the ViewModel is disposed.
    //}
    /*
    * String staffId,
        String buId,
        String isCreatedByMe,
        String buStaffId,
        String status,*/
    if (_uiState == UiState.loading) return;
    _uiState = UiState.loading;
    notifyListeners();
    try {
      final response = await ntdRepo.getTasks(
          staffId,
          selectedBU != null ? selectedBU!.compId : "0",
          selectedTab.toString(),
          buStaffId == "" ? "0" : buStaffId,
          statusTab.getData.second);
      _taskResponse = response;

      if (_taskResponse != null) {
        // get status counts
        _pending = _taskResponse!.data[0].pending.toString();
        _overdue = _taskResponse!.data[0].overdue.toString();
        _completed = _taskResponse!.data[0].completed.toString();
        // get tasks
        if (_tasks.isNotEmpty) {
          _tasks.clear();
        }
        if (_taskResponse!.data[0].tasks.isNotEmpty) {
          _tasks.addAll(_taskResponse!.data[0].tasks);
        } else {
          _message = "(No Data Found)";
        }
        _uiState = UiState.success;
      } else {
        _message = "Something went wrong, please try again later.";
        _uiState = UiState.error;
      }
    } catch (error) {
      _uiState = UiState.error;
      _message = error.toString();
      debugPrint(_message);
    } finally {
      notifyListeners();
    }
  }
}
