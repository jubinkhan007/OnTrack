import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tmbi/config/enum.dart';
import 'package:tmbi/config/extension_file.dart';
import 'package:tmbi/db/dao/pending_task_queue_dao.dart';
import 'package:tmbi/db/dao/pending_task_update_queue_dao.dart';
import 'package:tmbi/db/dao/sync_dao.dart';
import 'package:tmbi/models/new_task/bu_response.dart';
import 'package:tmbi/models/new_task/main_task_response.dart';
import 'package:tmbi/models/new_task/pending_task_queue_item.dart';
import 'package:tmbi/models/new_task/task_response.dart';
import 'package:tmbi/network/dio_exception.dart';
import 'package:tmbi/repo/new_task/new_task_dashboard_repo.dart';
import 'package:tmbi/repo/new_task/task_details_repo.dart';

import '../../network/ui_state.dart';
import '../../widgets/new_task/dropdown_type.dart';

class NewTaskDashboardViewmodel extends ChangeNotifier {
  final NewTaskDashboardRepo ntdRepo;
  final PendingTaskQueueDao _pendingTaskQueueDao = PendingTaskQueueDao();
  final PendingTaskUpdateQueueDao _pendingTaskUpdateQueueDao =
      PendingTaskUpdateQueueDao();
  late final TaskDetailsRepo _taskDetailsSyncRepo;
  final String staffId;
  final String name;

  NewTaskDashboardViewmodel(
      {required this.name, required this.staffId, required this.ntdRepo}) {
    _taskDetailsSyncRepo = TaskDetailsRepo(dio: ntdRepo.dio);
    _bootstrapQueue();
    _startPendingSyncTimer();
    getBUStaffs();
    //getTasks();
  }

  String _pending = "0";
  String _overdue = "0";
  String _completed = "0";

  // Verified counts from actual task list (per tab visit)
  final Map<TaskStatusFlag, String> _verifiedCounts = {};

  List<Task> _tasks = [];
  List<Task> _localPendingTasks = [];
  final Map<String, List<Task>> _completionCompletedByContext = {};

  List<BusinessUnit> _buStaffs = [];

  List<Task> get tasks {
    if (selectedTab == 0 && statusTab == TaskStatusFlag.pending) {
      // Only show local tasks that are NOT completed.
      final pendingLocal = _localPendingTasks
          .where((t) => t.completion.split('.').first != "100")
          .toList();
      return [...pendingLocal, ..._tasks];
    }
    if (statusTab == TaskStatusFlag.completed) {
      final derived = _completionCompletedByContext[_filterContextKey] ?? const [];
      // Include local tasks that ARE completed.
      final completedLocal = selectedTab == 0
          ? _localPendingTasks
              .where((t) => t.completion.split('.').first == "100")
              .toList()
          : <Task>[];
      final seen = <String>{};
      final out = <Task>[];
      for (final t in completedLocal) {
        if (seen.add(t.id)) out.add(t);
      }
      for (final t in derived) {
        if (seen.add(t.id)) out.add(t);
      }
      for (final t in _tasks) {
        if (seen.add(t.id)) out.add(t);
      }
      return out;
    }
    return _tasks;
  }

  List<BusinessUnit> get buStaffs => _buStaffs;

  String get pending {
    if (statusTab == TaskStatusFlag.pending) {
      return tasks.length.toString();
    }
    return _verifiedCounts[TaskStatusFlag.pending] ?? _pending;
  }

  String get overdue {
    if (statusTab == TaskStatusFlag.overdue) {
      return tasks.length.toString();
    }
    return _verifiedCounts[TaskStatusFlag.overdue] ?? _overdue;
  }

  String get completed {
    if (statusTab == TaskStatusFlag.completed) {
      return tasks.length.toString();
    }
    return _verifiedCounts[TaskStatusFlag.completed] ?? _completed;
  }

  bool? _isDeleted;

  bool? get isDeleted => _isDeleted;

  bool? _isTaskDeleted;

  bool? get isTaskDeleted => _isTaskDeleted;

  int selectedTab = 0; // 0=Created, 1=Assigned
  //TaskStatusFlag statusTab = TaskStatusFlag.all;
  TaskStatusFlag statusTab = TaskStatusFlag.pending;

  void changeTab(int index) {
    selectedTab = index;
    _verifiedCounts.clear();
    resetBuStaff();
    getTasks();
    notifyListeners();
  }

  void changeStatus(TaskStatusFlag status) {
    statusTab = status;
    getTasks();
    notifyListeners();
  }

  Future<void> showCreatedInQueue() async {
    // New tasks are always "Created By Me" and start in queue.
    // If user is on another tab/status, switch so the task is visible immediately.
    if (staffId.isEmail()) return; // email users are forced to Assigned tab
    selectedTab = 0;
    statusTab = TaskStatusFlag.pending;
    _verifiedCounts.clear();
    // Keep filters consistent with existing "Created" tab behavior.
    resetBuStaff();
    await getTasks();
    notifyListeners();
  }

  // bu search
  CompInfo? selectedBU;
  final Set<String> buOptions = {};
  final List<CompInfo> compInfoList = [];
  String buStaffId = "";

  void changeBU(CompInfo? ci) {
    selectedBU = ci;
    _verifiedCounts.clear();
    getTasks();
    notifyListeners();
  }

  void changeStaff(String staffId) {
    buStaffId = staffId;
    _verifiedCounts.clear();
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
  bool _reloadRequested = false;

  UiState get uiState => _uiState;

  set uiState(UiState newState) {
    if (_uiState != newState) {
      // only notify if the state has actually changed
      _uiState = newState;
      notifyListeners();
    }
  }

  Future<void> getTasks() async {
    if (_uiState == UiState.loading) {
      _reloadRequested = true;
      return;
    }

    // Prevent stale list from a previous status/tab from showing if this fetch fails.
    _tasks.clear();
    _message = null;
    await _loadVerifiedCountsCache();
    await _hydrateVerifiedCountsFromTaskSnapshots();
    _logCount("getTasks_start", extra: {
      "selectedTab": selectedTab,
      "statusTab": statusTab.name,
      "buId": selectedBU?.compId ?? "0",
      "staffFilter": buStaffId.isEmpty ? "0" : buStaffId,
      "localPending": _localPendingTasks.length,
    });

    _uiState = UiState.loading;
    notifyListeners();

    await syncPendingTaskUpdates();
    await syncPendingTasks(notifyOnChange: false);
    // Run again: syncPendingTasks may have remapped local_ IDs to real server
    // IDs, so previously-skipped updates can now be pushed.
    await syncPendingTaskUpdates();

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
      _message = null;

      if (_taskResponse != null && _taskResponse!.data.isNotEmpty) {
        final data = _taskResponse!.data[0];

        _pending = data.pending.toString();
        _overdue = data.overdue.toString();
        _completed = data.completed.toString();

        if (data.tasks.isNotEmpty) {
          _tasks.addAll(data.tasks);
          await _applyPendingUpdateQueueToTasks();
          _reclassifyCompletedByCompletion();
          await _applyPendingCommentCounts();
        }

        // Always trust the actual task list length over the server's count
        // for the currently active status tab.
        _syncCountWithTaskList();
        _logCount("getTasks_loaded_active_status", extra: {
          "serverPending": data.pending,
          "serverOverdue": data.overdue,
          "serverCompleted": data.completed,
          "serverTaskListLen": data.tasks.length,
          "activeListLenAfterOverlay": tasks.length,
          "verifiedCounts": _verifiedCounts.toString(),
        });

        if (_tasks.isEmpty && _localPendingTasks.isEmpty) {
          _message = "(no data found)";
        }

        _uiState = UiState.success;
        await _cacheLatestTaskSnapshot();
      } else if (_localPendingTasks.isEmpty) {
        _message = "(no data found)";
        _uiState = UiState.success; // still success, just empty
        await _cacheLatestTaskSnapshot();
      } else {
        _uiState = UiState.success;
        await _cacheLatestTaskSnapshot();
      }
    } on DioException catch (error) {
      if (_isOfflineError(error)) {
      final hasCache = await _loadCachedTaskSnapshot();
      if (hasCache) {
        await _applyPendingUpdateQueueToTasks();
        _reclassifyCompletedByCompletion();
        await _applyPendingCommentCounts();
        _syncCountWithTaskList();
      }
        if (!hasCache && _localPendingTasks.isEmpty) {
          _message = "No internet connection. Pull to refresh when online.";
        } else {
          _message = null;
        }
        _uiState = UiState.success;
      } else {
        _message = error.toString();
        _uiState = UiState.error;
      }
    } catch (e) {
      _message = e.toString();
      _uiState = UiState.error;
    } finally {
      // Fire background fetches for other tabs to get accurate counts
      if (_uiState == UiState.success) {
        await _fetchCountsForOtherTabs();
      }
      await _saveVerifiedCountsCache();
      _logCount("getTasks_done", extra: {
        "uiState": _uiState.name,
        "activeStatus": statusTab.name,
        "activeListLen": tasks.length,
        "pendingCard": pending,
        "overdueCard": overdue,
        "completedCard": completed,
        "verifiedCounts": _verifiedCounts.toString(),
      });
      notifyListeners();
      if (_reloadRequested) {
        _reloadRequested = false;
        Future.microtask(() async {
          await getTasks();
        });
      }
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
  String? _selectedStartDate = DateTime.now().toFormattedString(
    format: "yyyy-MM-dd",
  );
  String? _selectedEndDate = DateTime.now().toFormattedString(
    format: "yyyy-MM-dd",
  );

  String? get selectedStartDate => _selectedStartDate;
  String? get selectedEndDate => _selectedEndDate;
  String? get selectedDate => _selectedEndDate;

  void setStartDate(DateTime dateTime) {
    final formatted = "${dateTime.toLocal()}".split(' ')[0];
    _selectedStartDate = formatted;
    if (_selectedEndDate != null &&
        DateTime.parse(_selectedEndDate!).isBefore(dateTime)) {
      _selectedEndDate = formatted;
    }
    notifyListeners();
  }

  void setEndDate(DateTime dateTime) {
    final formatted = "${dateTime.toLocal()}".split(' ')[0];
    _selectedEndDate = formatted;
    if (_selectedStartDate != null &&
        DateTime.parse(_selectedStartDate!).isAfter(dateTime)) {
      _selectedStartDate = formatted;
    }
    notifyListeners();
  }

  void setDate(DateTime dateTime) {
    setEndDate(dateTime);
  }

  DateTime get startDateTime => DateTime.parse(
        _selectedStartDate ??
            DateTime.now().toFormattedString(format: "yyyy-MM-dd"),
      );

  DateTime get endDateTime => DateTime.parse(
        _selectedEndDate ??
            DateTime.now().toFormattedString(format: "yyyy-MM-dd"),
      );

  DateTime get todayDate {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  DateTime get minEndDate {
    final now = todayDate;
    final start = startDateTime;
    return start.isAfter(now) ? start : now;
  }

  DateTime get maxStartDate {
    final now = todayDate;
    final end = endDateTime;
    return end.isBefore(now) ? now : end;
  }

  String get effectiveStartDate =>
      _selectedStartDate ??
      DateTime.now().toFormattedString(
        format: "yyyy-MM-dd",
      );

  String get effectiveEndDate =>
      _selectedEndDate ??
      DateTime.now().toFormattedString(
        format: "yyyy-MM-dd",
      );

  void syncDateRange() {
    if (_selectedStartDate == null || _selectedEndDate == null) {
      return;
    }
    final start = DateTime.parse(_selectedStartDate!);
    final end = DateTime.parse(_selectedEndDate!);
    if (start.isAfter(end)) {
      _selectedEndDate = _selectedStartDate;
      notifyListeners();
    }
  }

  void ensureDateRangeDefaults() {
    _selectedStartDate ??= DateTime.now().toFormattedString(
      format: "yyyy-MM-dd",
    );
    _selectedEndDate ??= DateTime.now().toFormattedString(
      format: "yyyy-MM-dd",
    );
    syncDateRange();
    notifyListeners();
  }

  @override
  void dispose() {
    _pendingSyncTimer?.cancel();
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

  bool _isOfflineTaskSaved = false;

  bool get isOfflineTaskSaved => _isOfflineTaskSaved;

  int _pendingTaskQueueCount = 0;

  int get pendingTaskQueueCount => _pendingTaskQueueCount;

  bool _isSyncingPendingTasks = false;
  Timer? _pendingSyncTimer;

  Future<void> _bootstrapQueue() async {
    await _refreshLocalPendingTasks(notify: false);
    await _refreshPendingTaskQueueCount(notify: false);
    await _cleanupOrphanedLocalUpdates();
    await syncPendingTasks(notifyOnChange: false);
  }

  /// Remove update queue items with local_ IDs whose parent task
  /// no longer exists in the pending task queue (i.e. the task was
  /// already synced to the server but the remap failed).
  Future<void> _cleanupOrphanedLocalUpdates() async {
    final updates = await _pendingTaskUpdateQueueDao.getPendingUpdates();
    final localUpdates =
        updates.where((u) => u.inquiryId.startsWith("local_")).toList();
    if (localUpdates.isEmpty) return;

    final pendingTasks = await _pendingTaskQueueDao.getPendingTasks();
    final activeLocalIds =
        pendingTasks.map((t) => "local_${t.id ?? 0}").toSet();

    for (final update in localUpdates) {
      if (!activeLocalIds.contains(update.inquiryId) && update.id != null) {
        debugPrint(
            "[CLEANUP] Removing orphaned update: ${update.inquiryId}/${update.taskId} (${update.percentage}%)");
        await _pendingTaskUpdateQueueDao.deleteById(update.id!);
      }
    }
  }

  void _startPendingSyncTimer() {
    _pendingSyncTimer?.cancel();
    _pendingSyncTimer = Timer.periodic(const Duration(seconds: 20), (_) async {
      await syncPendingTaskUpdates();
      final didSync = await syncPendingTasks(notifyOnChange: false);
      if (didSync) {
        // Re-run: syncPendingTasks may have remapped local_ IDs to server IDs.
        await syncPendingTaskUpdates();
        if (_uiState != UiState.loading) {
          await getTasks();
        }
      }
    });
  }

  void resetTaskEntry() {
    taskTextEdit.text = "";
    taskDetailTextEdit.text = "";
    _canCreate = false;
    _selectedStartDate = DateTime.now().toFormattedString(
      format: "yyyy-MM-dd",
    );
    _selectedEndDate = DateTime.now().toFormattedString(
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
    _isOfflineTaskSaved = false;
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
    _isOfflineTaskSaved = false;
    notifyListeners();

    final payload = _buildTaskQueueItem(
      title: text.replaceAll("%", " percent "),
      details: textDetail.replaceAll("%", " percent "),
      dueDate: effectiveEndDate,
      startDate: effectiveStartDate,
      isSample: _selectedDropdownOption != null
          ? _selectedDropdownOption!.id == 1
              ? "Y"
              : "N"
          : "Y",
      priorityId: _selectedPriorityDropdownOption != null
          ? _selectedPriorityDropdownOption!.id.toString()
          : "1",
      assignees: _createAssigneesJSON(),
    );

    try {
      final response = await ntdRepo.saveTask(
          title: payload.title,
          details: payload.details,
          dueDate: payload.dueDate,
          startDate: payload.startDate,
          isSample: payload.isSample,
          priorityId: payload.priorityId,
          userId: staffId,
          assignees: payload.assignees);

      if (response) {
        taskTextEdit.clear();
        taskDetailTextEdit.clear();
        await getTasks();
      }

      _isSuccessTask = response;
      _uiStateTask = UiState.success;
    } on DioException catch (error) {
      if (_isOfflineError(error)) {
        final localId = await _pendingTaskQueueDao.enqueue(payload);
        await _createLocalTaskDetailsCache(localId, payload);
        await _refreshPendingTaskQueueCount(notify: false);
        await _refreshLocalPendingTasks(notify: false);
        taskTextEdit.clear();
        taskDetailTextEdit.clear();
        _isSuccessTask = true;
        _isOfflineTaskSaved = true;
        _uiStateTask = UiState.success;
        _message = null;
      } else {
        _uiStateTask = UiState.error;
        _message = error.toString();
      }
    } catch (error) {
      _uiStateTask = UiState.error;
      _message = error.toString();
    } finally {
      notifyListeners();
    }
  }

  Future<bool> syncPendingTasks({bool notifyOnChange = true}) async {
    if (_isSyncingPendingTasks) return false;
    _isSyncingPendingTasks = true;
    var didSyncAny = false;
    try {
      final pendingTasks = await _pendingTaskQueueDao.getPendingTasks();
      if (pendingTasks.isEmpty) {
        await _refreshLocalPendingTasks(notify: false);
        await _refreshPendingTaskQueueCount(notify: notifyOnChange);
        return didSyncAny;
      }

      for (final item in pendingTasks) {
        try {
          final localTaskId = "local_${item.id ?? 0}";
          final isSaved = await ntdRepo.saveTask(
            companyId: item.companyId,
            inquiryId: item.inquiryId,
            customerId: item.customerId,
            customerName: item.customerName,
            isSample: item.isSample,
            title: item.title,
            details: item.details,
            dueDate: item.dueDate,
            startDate: item.startDate,
            priorityId: item.priorityId,
            userId: item.userId,
            assignees: item.assignees,
          );
          if (isSaved && item.id != null) {
            debugPrint("[SYNC] Task '${item.title}' saved to server. Resolving server ID for $localTaskId...");
            final serverTaskId = await _resolveServerTaskIdForLocalTask(item);
            debugPrint("[SYNC] Resolved server ID: $serverTaskId");
            if (serverTaskId != null && serverTaskId.isNotEmpty) {
              await _remapLocalReferences(
                localTaskId: localTaskId,
                serverTaskId: serverTaskId,
              );
              debugPrint("[SYNC] Remapped $localTaskId → $serverTaskId");
            } else {
              debugPrint("[SYNC] WARNING: Could not resolve server ID for '${item.title}'");
            }
            await _pendingTaskQueueDao.deleteById(item.id!);
            didSyncAny = true;
            continue;
          }
          if (item.id != null) {
            await _pendingTaskQueueDao.incrementRetry(
                item.id!, item.retryCount);
          }
          break;
        } on DioException catch (error) {
          if (_isOfflineError(error)) {
            break;
          }
          if (item.id != null) {
            await _pendingTaskQueueDao.incrementRetry(
                item.id!, item.retryCount);
          }
          break;
        } catch (_) {
          if (item.id != null) {
            await _pendingTaskQueueDao.incrementRetry(
                item.id!, item.retryCount);
          }
          break;
        }
      }
    } finally {
      _isSyncingPendingTasks = false;
      await _refreshLocalPendingTasks(notify: false);
      await _refreshPendingTaskQueueCount(notify: notifyOnChange);
    }
    return didSyncAny;
  }

  PendingTaskQueueItem _buildTaskQueueItem({
    required String title,
    required String details,
    required String dueDate,
    required String startDate,
    required String isSample,
    required String priorityId,
    required String assignees,
  }) {
    return PendingTaskQueueItem(
      companyId: "0",
      inquiryId: "0",
      customerId: "0",
      customerName: "Other",
      isSample: isSample,
      title: title,
      details: details,
      dueDate: dueDate,
      startDate: startDate,
      priorityId: priorityId,
      userId: staffId,
      assignees: assignees,
      createdAt: DateTime.now().toIso8601String(),
    );
  }

  bool _isOfflineError(DioException error) {
    return error is NoInternetException ||
        error is TimeoutException ||
        error.type == DioExceptionType.connectionError ||
        error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.sendTimeout ||
        error.type == DioExceptionType.receiveTimeout;
  }

  Future<void> syncPendingTaskUpdates() async {
    final pendingUpdates = await _pendingTaskUpdateQueueDao.getPendingUpdates();
    if (pendingUpdates.isEmpty) return;
    debugPrint("[SYNC_UPDATES] Found ${pendingUpdates.length} pending updates");

    for (final item in pendingUpdates) {
      debugPrint("[SYNC_UPDATES] Item: inquiryId=${item.inquiryId}, taskId=${item.taskId}, percentage=${item.percentage}");
      if (item.inquiryId.startsWith("local_")) {
        debugPrint("[SYNC_UPDATES] Skipping local_ item: ${item.inquiryId}");
        // Wait until the local task is remapped to a real server id.
        continue;
      }
      try {
        final isUpdated = await _taskDetailsSyncRepo.updateTask(
          item.inquiryId,
          item.taskId,
          item.priorityId,
          item.description,
          item.userId,
          item.percentage,
          [],
        );
        if (isUpdated && item.id != null) {
          await _pendingTaskUpdateQueueDao.deleteById(item.id!);
          continue;
        }
        if (item.id != null) {
          await _pendingTaskUpdateQueueDao.incrementRetry(
            item.id!,
            item.retryCount,
          );
        }
        break;
      } on DioException catch (error) {
        if (_isOfflineError(error)) {
          break;
        }
        if (item.id != null) {
          await _pendingTaskUpdateQueueDao.incrementRetry(
            item.id!,
            item.retryCount,
          );
        }
        break;
      } catch (_) {
        if (item.id != null) {
          await _pendingTaskUpdateQueueDao.incrementRetry(
            item.id!,
            item.retryCount,
          );
        }
        break;
      }
    }
  }

  Future<void> _refreshPendingTaskQueueCount({bool notify = true}) async {
    _pendingTaskQueueCount = await _pendingTaskQueueDao.pendingCount();
    if (notify) {
      notifyListeners();
    }
  }

  Future<void> _refreshLocalPendingTasks({bool notify = true}) async {
    final pendingItems = await _pendingTaskQueueDao.getPendingTasks();
    final tasks = pendingItems.map(_toLocalTask).toList();
    final prefs = await SharedPreferences.getInstance();

    // Apply any queued offline updates (completion %) to local tasks.
    final updates = await _pendingTaskUpdateQueueDao.getPendingUpdates();
    final Map<String, String> latestCompletionByInquiry = {};
    for (final update in updates) {
      latestCompletionByInquiry[update.inquiryId] =
          update.percentage.split('.').first;
    }

    for (final task in tasks) {
      task.commentCount =
          _localCommentCountForInquiry(prefs, task.id).toString();
      final localCompletion = latestCompletionByInquiry[task.id];
      if (localCompletion != null && localCompletion.isNotEmpty) {
        task.completion = localCompletion;
        if (localCompletion == "100") {
          task.status = "Completed";
        }
      }
    }

    _localPendingTasks = tasks;
    if (notify) {
      notifyListeners();
    }
  }

  String get _filterContextKey {
    final buId = selectedBU?.compId ?? "0";
    final currentStaff = buStaffId.isEmpty ? "0" : buStaffId;
    return [staffId, selectedTab.toString(), buId, currentStaff].join("_");
  }

  void _reclassifyCompletedByCompletion() {
    if (_tasks.isEmpty) return;
    if (statusTab == TaskStatusFlag.completed) return;

    final moved = <Task>[];
    final remaining = <Task>[];

    for (final t in _tasks) {
      final isCompleted = t.completion.split('.').first == "100";
      if (isCompleted) {
        t.status = TaskStatusFlag.completed.getData.first;
        moved.add(t);
      } else {
        remaining.add(t);
      }
    }

    if (moved.isEmpty) return;
    _tasks
      ..clear()
      ..addAll(remaining);

    final existing = _completionCompletedByContext[_filterContextKey] ?? const [];
    final seen = <String>{};
    final merged = <Task>[];
    for (final t in existing) {
      if (seen.add(t.id)) merged.add(t);
    }
    for (final t in moved) {
      if (seen.add(t.id)) merged.add(t);
    }
    _completionCompletedByContext[_filterContextKey] = merged;
  }

  int _localCommentCountForInquiry(SharedPreferences prefs, String inquiryId) {
    // Dashboard card comment count should reflect only main-task comments.
    const mainSubTaskId = "0";
    final cacheKey = "comments_cache_${staffId}_${inquiryId}_$mainSubTaskId";
    final queueKey =
        "comments_pending_queue_${staffId}_${inquiryId}_$mainSubTaskId";
    final cachedCount = _countCachedComments(prefs, cacheKey);
    if (cachedCount > 0) return cachedCount;
    return _countPendingComments(prefs, queueKey);
  }

  int _countCachedComments(SharedPreferences prefs, String key) {
    final raw = prefs.getString(key);
    if (raw == null || raw.isEmpty) return 0;
    try {
      final decoded = jsonDecode(raw) as Map<String, dynamic>;
      final list = decoded["comments"] as List? ?? [];
      return list.length;
    } catch (_) {
      return 0;
    }
  }

  String get _taskCacheKey {
    final buId = selectedBU?.compId ?? "0";
    final currentStaff = buStaffId.isEmpty ? "0" : buStaffId;
    return "task_cache_${staffId}_${selectedTab}_${statusTab.name}_${buId}_$currentStaff";
  }

  String _taskCacheKeyForStatus(TaskStatusFlag status) {
    final buId = selectedBU?.compId ?? "0";
    final currentStaff = buStaffId.isEmpty ? "0" : buStaffId;
    return "task_cache_${staffId}_${selectedTab}_${status.name}_${buId}_$currentStaff";
  }

  Future<void> _cacheLatestTaskSnapshot() async {
    final prefs = await SharedPreferences.getInstance();
    final payload = {
      "pending": _pending,
      "overdue": _overdue,
      "completed": _completed,
      "tasks": _tasks.map((task) => task.toJson()).toList(),
      "cachedAt": DateTime.now().toIso8601String(),
    };
    await prefs.setString(_taskCacheKey, jsonEncode(payload));
  }

  Future<bool> _loadCachedTaskSnapshot() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_taskCacheKey);
    if (raw == null || raw.isEmpty) return false;

    try {
      final decoded = jsonDecode(raw) as Map<String, dynamic>;
      final cachedTasks = (decoded["tasks"] as List? ?? [])
          .map((item) => Task.fromJson(item as Map<String, dynamic>))
          .toList();
      _tasks
        ..clear()
        ..addAll(cachedTasks);
      _pending = (decoded["pending"] ?? "0").toString();
      _overdue = (decoded["overdue"] ?? "0").toString();
      _completed = (decoded["completed"] ?? "0").toString();
      return true;
    } catch (_) {
      return false;
    }
  }

  void _syncCountWithTaskList() {
    _verifiedCounts[statusTab] = tasks.length.toString();
    _logCount("syncCountWithTaskList", extra: {
      "status": statusTab.name,
      "value": _verifiedCounts[statusTab],
      "tasksLen": tasks.length,
      "verifiedCounts": _verifiedCounts.toString(),
    });
  }

  int _countsRequestVersion = 0;

  String get _verifiedCountsCacheKey {
    final buId = selectedBU?.compId ?? "0";
    final currentStaff = buStaffId.isEmpty ? "0" : buStaffId;
    return "task_verified_counts_${staffId}_${selectedTab}_${buId}_$currentStaff";
  }

  String get _countsContextKey {
    final buId = selectedBU?.compId ?? "0";
    final currentStaff = buStaffId.isEmpty ? "0" : buStaffId;
    return [
      staffId,
      selectedTab.toString(),
      statusTab.name,
      buId,
      currentStaff,
    ].join("_");
  }

  Future<void> _loadVerifiedCountsCache() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_verifiedCountsCacheKey);
    if (raw == null || raw.isEmpty) return;

    try {
      final decoded = jsonDecode(raw) as Map<String, dynamic>;
      for (final entry in decoded.entries) {
        final key = entry.key;
        final value = (entry.value ?? "0").toString();
        if (key == TaskStatusFlag.pending.name) {
          _verifiedCounts[TaskStatusFlag.pending] = value;
        } else if (key == TaskStatusFlag.overdue.name) {
          _verifiedCounts[TaskStatusFlag.overdue] = value;
        } else if (key == TaskStatusFlag.completed.name) {
          _verifiedCounts[TaskStatusFlag.completed] = value;
        }
      }
    } catch (_) {
      // Ignore malformed cache.
    }
  }

  Future<void> _saveVerifiedCountsCache() async {
    final prefs = await SharedPreferences.getInstance();
    final payload = <String, String>{};
    for (final entry in _verifiedCounts.entries) {
      payload[entry.key.name] = entry.value;
    }
    await prefs.setString(_verifiedCountsCacheKey, jsonEncode(payload));
  }

  Future<void> _hydrateVerifiedCountsFromTaskSnapshots() async {
    final prefs = await SharedPreferences.getInstance();
    final statuses = [
      TaskStatusFlag.pending,
      TaskStatusFlag.overdue,
      TaskStatusFlag.completed,
    ];

    for (final status in statuses) {
      if (_verifiedCounts.containsKey(status)) continue;
      final raw = prefs.getString(_taskCacheKeyForStatus(status));
      if (raw == null || raw.isEmpty) continue;
      try {
        final decoded = jsonDecode(raw) as Map<String, dynamic>;
        final cachedTasks = decoded["tasks"] as List? ?? [];
        var count = cachedTasks.length;
        if (status == TaskStatusFlag.pending && selectedTab == 0) {
          count += _localPendingTasks.length;
        }
        _verifiedCounts[status] = count.toString();
      } catch (_) {
        // Ignore malformed cache and continue.
      }
    }
  }

  /// After loading the active tab, fetch task counts for the other two tabs
  /// in the background so the status cards show accurate numbers immediately.
  Future<void> _fetchCountsForOtherTabs() async {
    final requestVersion = ++_countsRequestVersion;
    final contextKey = _countsContextKey;
    _logCount("fetchOther_start", extra: {
      "requestVersion": requestVersion,
      "contextKey": contextKey,
      "activeStatus": statusTab.name,
      "selectedTab": selectedTab,
      "localPending": _localPendingTasks.length,
    });

    final allStatuses = [
      TaskStatusFlag.pending,
      TaskStatusFlag.overdue,
      TaskStatusFlag.completed,
    ];

    for (final status in allStatuses) {
      if (status == statusTab) continue; // already verified

      try {
        _logCount("fetchOther_request", extra: {
          "requestVersion": requestVersion,
          "status": status.name,
          "contextKey": contextKey,
        });
        final response = await ntdRepo.getTasks(
          staffId,
          selectedBU != null ? selectedBU!.compId : "0",
          selectedTab.toString(),
          buStaffId.isEmpty ? "0" : buStaffId,
          status.getData.second,
        );

        if (requestVersion != _countsRequestVersion ||
            contextKey != _countsContextKey) {
          _logCount("fetchOther_discard_stale", extra: {
            "requestVersion": requestVersion,
            "latestVersion": _countsRequestVersion,
            "status": status.name,
            "contextKey": contextKey,
            "latestContextKey": _countsContextKey,
          });
          return;
        }

        if (response.data.isNotEmpty) {
          var fetchedCount = response.data[0].tasks.length;
          if (status == TaskStatusFlag.pending && selectedTab == 0) {
            fetchedCount += _localPendingTasks.length;
          }
          _verifiedCounts[status] = fetchedCount.toString();
          _logCount("fetchOther_set_count", extra: {
            "requestVersion": requestVersion,
            "status": status.name,
            "serverTaskListLen": response.data[0].tasks.length,
            "storedCount": _verifiedCounts[status],
            "verifiedCounts": _verifiedCounts.toString(),
          });
        } else {
          if (status == TaskStatusFlag.pending && selectedTab == 0) {
            _verifiedCounts[status] = _localPendingTasks.length.toString();
          } else {
            _verifiedCounts[status] = "0";
          }
          _logCount("fetchOther_set_empty", extra: {
            "requestVersion": requestVersion,
            "status": status.name,
            "storedCount": _verifiedCounts[status],
            "verifiedCounts": _verifiedCounts.toString(),
          });
        }
        notifyListeners();
      } catch (e) {
        _logCount("fetchOther_error", extra: {
          "requestVersion": requestVersion,
          "status": status.name,
          "error": e.toString(),
        });
        // If a background fetch fails, keep the server count as fallback
      }
    }
    _logCount("fetchOther_done", extra: {
      "requestVersion": requestVersion,
      "contextKey": contextKey,
      "verifiedCounts": _verifiedCounts.toString(),
    });
  }

  void _logCount(String event, {Map<String, Object?> extra = const {}}) {
    final payload = {
      "event": event,
      "staffId": staffId,
      ...extra,
    };
    debugPrint("[TASK_COUNT] ${jsonEncode(payload)}");
  }

  Future<void> _applyPendingCommentCounts() async {
    if (_tasks.isEmpty) return;
    final prefs = await SharedPreferences.getInstance();

    for (final task in _tasks) {
      // Main task card comment count should reflect main-task comments (subTaskId=0).
      final cacheMainKey = "comments_cache_${staffId}_${task.id}_0";
      final mainQueueKey = "comments_pending_queue_${staffId}_${task.id}_0";
      final serverCount = int.tryParse(task.commentCount) ?? 0;
      final cachedMainCount = _countCachedComments(prefs, cacheMainKey);
      final pendingMainCount = _countPendingComments(prefs, mainQueueKey);
      final localMainCount =
          cachedMainCount > pendingMainCount ? cachedMainCount : pendingMainCount;
      final effectiveCount =
          serverCount > localMainCount ? serverCount : localMainCount;
      task.commentCount = effectiveCount.toString();
    }
  }

  int _countPendingComments(SharedPreferences prefs, String key) {
    final raw = prefs.getString(key);
    if (raw == null || raw.isEmpty) return 0;
    try {
      final decoded = jsonDecode(raw) as List;
      return decoded.length;
    } catch (_) {
      return 0;
    }
  }

  Future<void> _applyPendingUpdateQueueToTasks() async {
    if (_tasks.isEmpty) return;
    final updates = await _pendingTaskUpdateQueueDao.getPendingUpdates();
    if (updates.isEmpty) return;

    // Keep latest offline update per main task (inquiry).
    final Map<String, String> latestCompletionByInquiry = {};
    for (final update in updates) {
      latestCompletionByInquiry[update.inquiryId] =
          update.percentage.split('.').first;
    }

    for (final task in _tasks) {
      final localCompletion = latestCompletionByInquiry[task.id];
      if (localCompletion != null && localCompletion.isNotEmpty) {
        task.completion = localCompletion;
      }
    }
  }

  Task _toLocalTask(PendingTaskQueueItem item) {
    var assignName = "You";
    try {
      final decoded = jsonDecode(item.assignees);
      if (decoded is List && decoded.isNotEmpty) {
        final first = decoded.first;
        if (first is Map && first["NAME"] != null) {
          assignName = first["NAME"].toString();
        }
      }
    } catch (_) {}

    return Task(
      tnstHris: item.userId,
      id: "local_${item.id ?? 0}",
      name: "${item.title} (Pending Sync)",
      assignToId: item.userId,
      assignToName: assignName,
      completion: "0",
      createdDate: item.createdAt,
      status: "In Queue",
      commentCount: "0",
    );
  }

  Future<void> _createLocalTaskDetailsCache(
      int localId, PendingTaskQueueItem item) async {
    final localTaskId = "local_$localId";
    final localSubTaskId = "local_subtask_$localId";
    final payload = MainTaskResponse(
      data: [
        MainTask(
          mainTaskId: localTaskId,
          mainTaskName: item.title,
          mainTaskDetail: item.details,
          totalCompletion: "0",
          date: "${item.startDate} to ${item.dueDate} (local)",
          status: "In Queue",
          tasks: [
            SubTask(
              id: localSubTaskId,
              name: item.title,
              assignToId: item.userId,
              assignToName: name,
              completion: "0",
              date: "${item.startDate} - ${item.dueDate}",
              status: "In Queue",
              lastComment: "null",
              commentCount: "0",
            ),
          ],
        ),
      ],
    );
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      "task_details_cache_${staffId}_$localTaskId",
      jsonEncode(payload.toJson()),
    );
  }

  Future<String?> _resolveServerTaskIdForLocalTask(
      PendingTaskQueueItem localItem) async {
    try {
      // Use "999" (All) for buId — using "0" returns empty data from the server.
      final response = await ntdRepo.getTasks(
        staffId,
        "999",
        "0",
        "0",
        TaskStatusFlag.pending.getData.second,
      );
      if (response.data.isEmpty) return null;
      final tasks = response.data.first.tasks;
      if (tasks.isEmpty) return null;

      final exact = tasks.where((t) => t.name == localItem.title).toList();
      if (exact.isNotEmpty) {
        exact.sort((a, b) => b.createdDate.compareTo(a.createdDate));
        debugPrint("[SYNC] Found server task: id=${exact.first.id}, name=${exact.first.name}");
        return exact.first.id;
      }
      debugPrint("[SYNC] No name match found for '${localItem.title}' among ${tasks.length} tasks");
      return null;
    } catch (e) {
      debugPrint("[SYNC] _resolveServerTaskIdForLocalTask error: $e");
      return null;
    }
  }

  Future<void> _remapLocalReferences({
    required String localTaskId,
    required String serverTaskId,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final localNumericId = localTaskId.replaceFirst("local_", "");
    final localSubTaskId = "local_subtask_$localNumericId";

    String? serverSubTaskId;
    try {
      final details =
          await _taskDetailsSyncRepo.getSubTasks(staffId, serverTaskId);
      if (details.data.isNotEmpty && details.data.first.tasks.isNotEmpty) {
        serverSubTaskId = details.data.first.tasks.first.id;
      }
    } catch (_) {}

    debugPrint("[REMAP] Remapping inquiryId: $localTaskId → $serverTaskId");
    await _pendingTaskUpdateQueueDao.remapInquiryId(localTaskId, serverTaskId);
    debugPrint("[REMAP] Remapping taskId: $localSubTaskId → $serverSubTaskId");
    if (serverSubTaskId != null) {
      await _pendingTaskUpdateQueueDao.remapTaskId(
          localSubTaskId, serverSubTaskId);
    }

    final allKeys = prefs.getKeys();
    for (final key in allKeys) {
      if (key.contains("_$localTaskId")) {
        final raw = prefs.getString(key);
        if (raw == null) continue;

        // For pending comment queues, sync them to the server and then clear.
        // Keeping stale pending items causes duplicates because the server
        // dateTime format differs from local.
        if (key.startsWith("comments_pending_queue_")) {
          await _syncAndClearPendingCommentQueue(
            prefs, key, serverTaskId, serverSubTaskId,
          );
          continue;
        }

        final newKey = key.replaceAll(localTaskId, serverTaskId).replaceAll(
              localSubTaskId,
              serverSubTaskId ?? localSubTaskId,
            );
        await prefs.setString(newKey, raw);
        await prefs.remove(key);
      }
    }
  }

  /// Sync pending comments from a local queue to the server, then clear.
  Future<void> _syncAndClearPendingCommentQueue(
    SharedPreferences prefs,
    String queueKey,
    String serverTaskId,
    String? serverSubTaskId,
  ) async {
    final raw = prefs.getString(queueKey);
    if (raw == null || raw.isEmpty) {
      await prefs.remove(queueKey);
      return;
    }

    try {
      final decoded = jsonDecode(raw) as List;
      final pending =
          decoded.map((e) => Map<String, dynamic>.from(e as Map)).toList();

      // Determine the taskId for the API call.
      // Queue key format: comments_pending_queue_{staffId}_{inqId}_{subTaskId}
      // Main-task comments end with "_0", sub-task comments end with the sub-task ID.
      final isMainTaskComment = queueKey.endsWith("_0");
      final taskId = isMainTaskComment ? "0" : (serverSubTaskId ?? "0");

      for (final p in pending) {
        final body = (p["body"] ?? "").toString();
        final userId = (p["userId"] ?? staffId).toString();
        if (body.isEmpty) continue;
        try {
          await _taskDetailsSyncRepo.updateTask(
            serverTaskId, taskId, "0", body, userId, "0", [],
          );
          debugPrint("[REMAP] Synced pending comment '$body' to $serverTaskId/$taskId");
        } catch (e) {
          debugPrint("[REMAP] Failed to sync comment '$body': $e");
        }
      }
    } catch (e) {
      debugPrint("[REMAP] Error parsing pending comment queue: $e");
    }

    await prefs.remove(queueKey);
    debugPrint("[REMAP] Cleared pending comment queue: $queueKey");
  }

  String _createAssigneesJSON() {
    final List<Map<String, dynamic>> assignedTasks = [];

    if (_selectedStaffs.isNotEmpty) {
      for (var user in _selectedStaffs) {
        assignedTasks.add({
          "NAME": user.userName,
          "STAFFID": user.userHris.toString(),
          "DATETIME": effectiveEndDate,
          "STARTDATE": effectiveStartDate,
          "ENDDATE": effectiveEndDate,
          "COMMENTS": taskTextEdit.text.replaceAll("%", " percent "),
        });
      }
    } else {
      assignedTasks.add({
        "NAME": name,
        "STAFFID": staffId,
        "DATETIME": effectiveEndDate,
        "STARTDATE": effectiveStartDate,
        "ENDDATE": effectiveEndDate,
        "COMMENTS": taskTextEdit.text.replaceAll("%", " percent "),
      });
    }
    return assignedTasks.isNotEmpty ? jsonEncode(assignedTasks) : "";
  }
}
