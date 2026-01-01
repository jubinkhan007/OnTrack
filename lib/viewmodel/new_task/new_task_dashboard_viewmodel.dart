import 'dart:convert';

import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:tmbi/config/enum.dart';
import 'package:tmbi/config/extension_file.dart';
import 'package:tmbi/db/dao/sync_dao.dart';
import 'package:tmbi/models/new_task/bu_response.dart';
import 'package:tmbi/models/new_task/task_response.dart';
import 'package:tmbi/repo/new_task/new_task_dashboard_repo.dart';

import '../../network/ui_state.dart';
import '../../widgets/new_task/dropdown_type.dart';

class NewTaskDashboardViewmodel extends ChangeNotifier {
  final NewTaskDashboardRepo ntdRepo;
  final String staffId;
  final String name;

  NewTaskDashboardViewmodel(
      {required this.name, required this.staffId, required this.ntdRepo}) {
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

  Future<void> deleteTask(String inquiryId) async {
    if (_uiState == UiState.loading) return;

    _uiState = UiState.loading;
    notifyListeners();
    try {
      final response = await ntdRepo.deleteTask(inquiryId);
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

  /// NEW TASK ENTRY \\\
  TextEditingController taskTextEdit = TextEditingController();
  TextEditingController taskDetailTextEdit = TextEditingController();
  TextEditingController searchTextEdit = TextEditingController();
  String? _selectedDate = DateTime.now().toFormattedString(
    format: "yyyy-MM-dd",
  );

  String? get selectedDate => _selectedDate;

  void setDate(DateTime dateTime) {
    _selectedDate = "${dateTime.toLocal()}".split(' ')[0];
    notifyListeners();
  }

  @override
  void dispose() {
    taskTextEdit.dispose();
    taskDetailTextEdit.dispose();
    searchTextEdit.dispose();
    super.dispose();
  }

  bool _canCreate = false;

  bool get canCreate => _canCreate;

  void onTaskTextChanged(String value) {
    _canCreate = value.trim().isNotEmpty;
    notifyListeners();
  }

  final List<BusinessUnit> _selectedStaffs = [];

  List<BusinessUnit> get selectedStaffs => _selectedStaffs;

  String _search = '';

  // available staffs (excluding selected)
  List<BusinessUnit> get availableStaffs {
    final list = _buStaffs.where((c) => !_selectedStaffs.contains(c)).toList();
    if (_search.isEmpty) return list;
    return list
        .where(
          (c) => c.userName.toLowerCase().contains(_search.toLowerCase()),
        )
        .toList();
  }

  void add(BusinessUnit customer) {
    _selectedStaffs.add(customer);
    notifyListeners();
  }

  void remove(BusinessUnit customer) {
    _selectedStaffs.remove(customer);
    notifyListeners();
  }

  void search(String value) {
    _search = value;
    notifyListeners();
  }

  /// DROPDOWN ITEM \\\

  DropdownOption? _selectedDropdownOption;

  DropdownOption? get selectedDropdownOption => _selectedDropdownOption;

  DropdownOption? _selectedPriorityDropdownOption;

  DropdownOption? get selectedPriorityDropdownOption =>
      _selectedPriorityDropdownOption;


  void reset() {
    buStaffId = "";
    selectedBU = compInfoList.first;
    selectedTab = 0;
    statusTab = TaskStatusFlag.pending;
    _selectedDropdownOption = null;
    _selectedPriorityDropdownOption = null;
    setStaffName("");
    clearStaff();
  }

  void setDropDownValue(DropdownOption option) {
    _selectedDropdownOption = option;
    notifyListeners();
  }

  void setPriorityDropDownValue(DropdownOption option) {
    _selectedPriorityDropdownOption = option;
    notifyListeners();
  }

  // UI state
  UiState _uiStateTask = UiState.init;

  UiState get uiStateTask => _uiStateTask;

  set uiStateTask(UiState newState) {
    if (_uiStateTask != newState) {
      _uiStateTask = newState;
      notifyListeners();
    }
  }

  bool _isSuccessTask = false;

  bool get isSuccessTask => _isSuccessTask;

  void resetTaskEntry() {
    taskTextEdit.text = "";
    taskDetailTextEdit.text = "";
    _canCreate = false;
    _selectedDate = DateTime.now().toFormattedString(
      format: "yyyy-MM-dd",
    );
    _selectedStaffs.clear();
    _search = '';
    _selectedDropdownOption = DropdownOption(
      id: 1,
      icon: Icons.circle_outlined,
      label: 'TO DO',
    );
    _selectedPriorityDropdownOption = null;
    _isSuccessTask = false;
    notifyListeners();
  }

  Future<void> saveTask() async {
    final text = taskTextEdit.text.trim();
    String textDetail = taskDetailTextEdit.text.trim();
    if (text.isEmpty) return;
    if (textDetail.isEmpty) textDetail = "-";

    if (_uiStateTask == UiState.loading) return;
    _uiStateTask = UiState.loading;
    _isSuccessTask = false;
    notifyListeners();
    try {
      final response = await ntdRepo.saveTask(
          title: text.replaceAll("%", " percent "),
          details: textDetail.replaceAll("%", " percent "),
          dueDate: _selectedDate ??
              DateTime.now().toFormattedString(
                format: "yyyy-MM-dd",
              ),
          isSample: _selectedDropdownOption != null ? _selectedDropdownOption!.id == 1 ? "Y": "N" : "Y",
          priorityId: _selectedPriorityDropdownOption != null
              ? _selectedPriorityDropdownOption!.id.toString()
              : "1",
          userId: staffId,
          assignees: _createAssigneesJSON());

      if (response) {
        taskTextEdit.clear();
        taskDetailTextEdit.clear();
        await getTasks();
      }

      _isSuccessTask = response;
      _uiStateTask = UiState.success;
    } catch (error) {
      _uiStateTask = UiState.error;
      _message = error.toString();
    } finally {
      notifyListeners();
    }
  }

  String _createAssigneesJSON() {
    final List<Map<String, dynamic>> assignedTasks = [];

    if (_selectedStaffs.isNotEmpty) {
      for (var user in _selectedStaffs) {
        assignedTasks.add({
          "NAME": user.userName,
          "STAFFID": user.userHris.toString(),
          "DATETIME": _selectedDate, // make sure this is already formatted
          "COMMENTS": taskTextEdit.text.replaceAll("%", " percent "),
        });
      }
    } else {
      assignedTasks.add({
        "NAME": name,
        "STAFFID": staffId,
        "DATETIME": _selectedDate,
        "COMMENTS": taskTextEdit.text.replaceAll("%", " percent "),
      });
    }
    return assignedTasks.isNotEmpty ? jsonEncode(assignedTasks) : "";
  }


}
