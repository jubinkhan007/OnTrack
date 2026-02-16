import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tmbi/db/dao/pending_task_update_queue_dao.dart';
import 'package:tmbi/models/new_task/main_task_response.dart';
import 'package:tmbi/models/new_task/pending_task_update_queue_item.dart';
import 'package:tmbi/network/dio_exception.dart';
import 'package:tmbi/repo/new_task/task_details_repo.dart';

import '../../network/ui_state.dart';

class TaskDetailsViewmodel extends ChangeNotifier {
  final TaskDetailsRepo taskDetailsRepo;
  final PendingTaskUpdateQueueDao _pendingTaskUpdateQueueDao =
      PendingTaskUpdateQueueDao();
  bool _disposed = false;
  Timer? _pendingSyncTimer;

  TaskDetailsViewmodel({required this.taskDetailsRepo}) {
    _startPendingSyncTimer();
  }

  @override
  void dispose() {
    _pendingSyncTimer?.cancel();
    _disposed = true;
    super.dispose();
  }

  // --- API --- \\
  String? _message;

  String? get message => _message;

  MainTaskResponse? _mainTaskResponse;

  MainTaskResponse? get mainTaskResponse => _mainTaskResponse;

  final List<SubTask> _subtasks = [];

  List<SubTask> get subtasks => _subtasks;

  bool? _isUpdated;

  bool? get isUpdated => _isUpdated;

  bool _isOfflineUpdateSaved = false;

  bool get isOfflineUpdateSaved => _isOfflineUpdateSaved;

  // UI state
  UiState _uiState = UiState.init;

  UiState get uiState => _uiState;

  String _toErrorMessage(Object error) {
    const exceptionPrefix = 'Exception: ';
    final raw = error.toString();
    return raw.startsWith(exceptionPrefix)
        ? raw.substring(exceptionPrefix.length)
        : raw;
  }

  set uiState(UiState newState) {
    if (_uiState != newState) {
      _uiState = newState;
      notifyListeners();
    }
  }

  Future<void> getSubTasks(String staffId, String taskId) async {
    if (_disposed) {
      return;
    }
    if (_uiState == UiState.loading) return;
    _uiState = UiState.loading;

    _subtasks.clear();
    _mainTaskResponse = null;

    notifyListeners();

    if (_isLocalTaskId(taskId)) {
      final hasCache = await _loadCachedTaskDetails(staffId, taskId);
      if (hasCache) {
        await _applyQueuedUpdatesToCurrentTask(taskId);
        _message = null;
        _uiState = UiState.success;
      } else {
        _uiState = UiState.error;
        _message = "(no data found)";
      }
      notifyListeners();
      return;
    }

    await syncPendingUpdates();

    try {
      final response = await taskDetailsRepo.getSubTasks(staffId, taskId);
      _mainTaskResponse = response;

      if (_mainTaskResponse != null) {
        if (_mainTaskResponse!.data.isNotEmpty) {
          if (_mainTaskResponse!.data.first.tasks.isNotEmpty) {
            _subtasks.addAll(_mainTaskResponse!.data.first.tasks);
          } else {
            _message = "(no data found)";
          }
        } else {
          _message = "(no data found)";
        }
        await _applyQueuedUpdatesToCurrentTask(taskId);
        _uiState = UiState.success;
        await _cacheTaskDetails(staffId, taskId, _mainTaskResponse!);
      } else {
        _message = "Something went wrong, please try again.";
        _uiState = UiState.error;
      }
      _startPendingSyncTimer();
    } on DioException catch (error) {
      if (_isOfflineError(error)) {
        final hasCache = await _loadCachedTaskDetails(staffId, taskId);
        if (hasCache) {
          await _applyQueuedUpdatesToCurrentTask(taskId);
          _message = null;
          _uiState = UiState.success;
        } else {
          _uiState = UiState.error;
          _message = "No internet detected, please check your connection.";
        }
      } else {
        _uiState = UiState.error;
        _message = _toErrorMessage(error);
      }
      debugPrint(_message);
    } catch (error) {
      _uiState = UiState.error;
      _message = _toErrorMessage(error);
      debugPrint(_message);
    } finally {
      notifyListeners();
    }
  }

  /*await inquiryViewModel.updateTask(
            inquiryResponse.id.toString(),
            pair.first!.id.toString(),
            HomeFlagItem().priorities[3].id.toString(),
            "Successfully completed the task",
            widget.staffId,
            100, []);*/

  Future<void> updateTask(
      String inquiryId,
      String taskId,
      String priorityId,
      String description,
      String userId,
      String percentage,
      List<String> fileNames) async {
    if (_uiState == UiState.loading) return;

    _uiState = UiState.loading;
    _message = null;
    _isOfflineUpdateSaved = false;
    notifyListeners();

    final pctInt = double.tryParse(percentage)?.round() ??
        int.tryParse(percentage.split('.').first) ??
        0;
    final effectivePriorityId = pctInt >= 100 ? "7" : priorityId;
    final effectivePercentage = pctInt >= 100 ? "100" : percentage;
    final queuedUpdate = PendingTaskUpdateQueueItem(
      inquiryId: inquiryId,
      taskId: taskId,
      priorityId: effectivePriorityId,
      description: description,
      userId: userId,
      percentage: effectivePercentage,
      createdAt: DateTime.now().toIso8601String(),
    );

    if (_isLocalTaskId(inquiryId)) {
      await _pendingTaskUpdateQueueDao.enqueue(queuedUpdate);
      _applyLocalSubtaskUpdate(
        taskId,
        percentage,
        note: description,
      );
      await _applyCachedSubtaskUpdate(
        userId,
        inquiryId,
        taskId,
        percentage,
        note: description,
      );
      await _updateDashboardTaskCachesForInquiry(
        userId,
        inquiryId,
        _calculateMainCompletionFromCurrentDetails(fallback: percentage),
      );
      _isUpdated = true;
      _isOfflineUpdateSaved = true;
      _uiState = UiState.success;
      notifyListeners();
      return;
    }
    try {
      final response = await taskDetailsRepo.updateTask(inquiryId, taskId,
          effectivePriorityId,
          description,
          userId,
          effectivePercentage,
          fileNames);
      _isUpdated = response;
      _uiState = UiState.success;
    } on DioException catch (error) {
      if (_isOfflineError(error)) {
        await _pendingTaskUpdateQueueDao.enqueue(queuedUpdate);
        _applyLocalSubtaskUpdate(
          taskId,
          effectivePercentage,
          note: description,
        );
        await _applyCachedSubtaskUpdate(
          userId,
          inquiryId,
          taskId,
          effectivePercentage,
          note: description,
        );
        await _updateDashboardTaskCachesForInquiry(
          userId,
          inquiryId,
          _calculateMainCompletionFromCurrentDetails(
            fallback: effectivePercentage,
          ),
        );
        _isUpdated = true;
        _isOfflineUpdateSaved = true;
        _uiState = UiState.success;
      } else {
        _uiState = UiState.error;
        _message = _toErrorMessage(error);
      }
    } catch (error) {
      _uiState = UiState.error;
      _message = _toErrorMessage(error);
    } finally {
      notifyListeners();
    }
  }

  Future<bool> syncPendingUpdates() async {
    final pendingUpdates = await _pendingTaskUpdateQueueDao.getPendingUpdates();
    if (pendingUpdates.isEmpty) return false;

    var didSyncAny = false;
    for (final item in pendingUpdates) {
      if (_isLocalTaskId(item.inquiryId)) {
        continue;
      }
      try {
        final isUpdated = await taskDetailsRepo.updateTask(
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
          didSyncAny = true;
        } else if (item.id != null) {
          await _pendingTaskUpdateQueueDao.incrementRetry(
            item.id!,
            item.retryCount,
          );
          break;
        }
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
    return didSyncAny;
  }

  void _startPendingSyncTimer() {
    _pendingSyncTimer?.cancel();
    _pendingSyncTimer = Timer.periodic(const Duration(seconds: 20), (_) async {
      final didSync = await syncPendingUpdates();
      if (didSync && !_disposed) {
        notifyListeners();
      }
    });
  }

  void _applyLocalSubtaskUpdate(
    String taskId,
    String percentage, {
    String? note,
  }) {
    final newCompletion = percentage.split('.').first;
    final shouldAddNote = _hasNote(note);
    if (_mainTaskResponse != null &&
        _mainTaskResponse!.data.isNotEmpty &&
        _mainTaskResponse!.data.first.tasks.isNotEmpty) {
      for (final subtask in _mainTaskResponse!.data.first.tasks) {
        if (subtask.id == taskId) {
          subtask.completion = newCompletion;
          if (shouldAddNote) {
            _applyNoteMeta(subtask);
          }
        }
      }
      _subtasks
        ..clear()
        ..addAll(_mainTaskResponse!.data.first.tasks);
      return;
    }

    for (final subtask in _subtasks) {
      if (subtask.id == taskId) {
        subtask.completion = newCompletion;
        if (shouldAddNote) {
          _applyNoteMeta(subtask);
        }
      }
    }
  }

  bool _isOfflineError(DioException error) {
    return error is NoInternetException ||
        error is TimeoutException ||
        error.type == DioExceptionType.connectionError ||
        error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.sendTimeout ||
        error.type == DioExceptionType.receiveTimeout;
  }

  bool _isLocalTaskId(String taskId) => taskId.startsWith("local_");

  Future<void> _applyQueuedUpdatesToCurrentTask(String inquiryId) async {
    final pendingUpdates = await _pendingTaskUpdateQueueDao.getPendingUpdates();
    final related = pendingUpdates.where((u) => u.inquiryId == inquiryId);
    for (final item in related) {
      _applyLocalSubtaskUpdate(item.taskId, item.percentage);
    }
  }

  String _taskDetailsCacheKey(String staffId, String taskId) {
    return "task_details_cache_${staffId}_$taskId";
  }

  Future<void> _cacheTaskDetails(
      String staffId, String taskId, MainTaskResponse response) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _taskDetailsCacheKey(staffId, taskId),
      jsonEncode(response.toJson()),
    );
  }

  Future<bool> _loadCachedTaskDetails(String staffId, String taskId) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_taskDetailsCacheKey(staffId, taskId));
    if (raw == null || raw.isEmpty) return false;

    try {
      final decoded = jsonDecode(raw) as Map<String, dynamic>;
      final cached = MainTaskResponse.fromJson(decoded);
      _mainTaskResponse = cached;
      _subtasks
        ..clear()
        ..addAll(
          cached.data.isNotEmpty ? cached.data.first.tasks : <SubTask>[],
        );
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<void> _applyCachedSubtaskUpdate(
    String staffId,
    String inquiryId,
    String subTaskId,
    String percentage,
    {String? note}
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final key = _taskDetailsCacheKey(staffId, inquiryId);
    final raw = prefs.getString(key);
    if (raw == null || raw.isEmpty) return;

    try {
      final decoded = jsonDecode(raw) as Map<String, dynamic>;
      final cached = MainTaskResponse.fromJson(decoded);
      if (cached.data.isNotEmpty) {
        for (final sub in cached.data.first.tasks) {
          if (sub.id == subTaskId) {
            sub.completion = percentage.split('.').first;
            if (_hasNote(note)) {
              _applyNoteMeta(sub);
            }
          }
        }
      }
      await prefs.setString(key, jsonEncode(cached.toJson()));
      if (_hasNote(note)) {
        await _appendLocalNoteToCommentCache(
          staffId: staffId,
          inquiryId: inquiryId,
          subTaskId: subTaskId,
          note: note!.trim(),
        );
      }
    } catch (_) {
      // Ignore malformed cache and keep queue entry for future sync
    }
  }

  bool _hasNote(String? note) {
    final normalized = (note ?? "").trim();
    return normalized.isNotEmpty && normalized != "-";
  }

  void _applyNoteMeta(SubTask subtask) {
    final currentCount = int.tryParse(subtask.commentCount) ?? 0;
    final nextCount = currentCount + 1;
    subtask.commentCount = nextCount.toString();
    subtask.lastComment = nextCount.toString();
  }

  Future<void> _appendLocalNoteToCommentCache({
    required String staffId,
    required String inquiryId,
    required String subTaskId,
    required String note,
  }) async {
    if (inquiryId.isEmpty || subTaskId.isEmpty) return;

    final prefs = await SharedPreferences.getInstance();
    final key = "comments_cache_${staffId}_${inquiryId}_$subTaskId";
    final existing = prefs.getString(key);
    final now = DateTime.now().toIso8601String();

    final current = <Map<String, dynamic>>[];
    if (existing != null && existing.isNotEmpty) {
      try {
        final decoded = jsonDecode(existing) as Map<String, dynamic>;
        final comments = decoded["comments"] as List? ?? [];
        for (final item in comments) {
          if (item is Map<String, dynamic>) {
            current.add(Map<String, dynamic>.from(item));
          }
        }
      } catch (_) {
        // keep empty on malformed cached payload
      }
    }

    current.add({
      "NAME": "You",
      "STAFFID": staffId,
      "DATETIME": now,
      "COMMENTS": note,
    });

    final payload = {
      "comments": current,
      "cachedAt": now,
    };
    await prefs.setString(key, jsonEncode(payload));
  }

  String _calculateMainCompletionFromCurrentDetails(
      {required String fallback}) {
    final normalizedFallback = fallback.split('.').first;
    if (_mainTaskResponse == null ||
        _mainTaskResponse!.data.isEmpty ||
        _mainTaskResponse!.data.first.tasks.isEmpty) {
      return normalizedFallback;
    }

    final taskList = _mainTaskResponse!.data.first.tasks;
    var sum = 0.0;
    var count = 0;
    for (final sub in taskList) {
      final value = double.tryParse(sub.completion);
      if (value != null) {
        sum += value;
        count += 1;
      }
    }
    if (count == 0) return normalizedFallback;
    return (sum / count).round().toString();
  }

  Future<void> _updateDashboardTaskCachesForInquiry(
    String staffId,
    String inquiryId,
    String completion,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final prefix = "task_cache_${staffId}_";
    final keys = prefs.getKeys().where((key) => key.startsWith(prefix));

    for (final key in keys) {
      final raw = prefs.getString(key);
      if (raw == null || raw.isEmpty) continue;

      try {
        final decoded = jsonDecode(raw) as Map<String, dynamic>;
        final taskList = decoded["tasks"] as List? ?? [];
        var updated = false;

        for (final item in taskList) {
          if (item is Map<String, dynamic> &&
              item["ID"] != null &&
              item["ID"].toString() == inquiryId) {
            item["COMPLETION"] = completion;
            updated = true;
          }
        }

        if (updated) {
          await prefs.setString(key, jsonEncode(decoded));
        }
      } catch (_) {
        // Skip malformed cache entries
      }
    }
  }
}
