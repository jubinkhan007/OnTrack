import 'package:flutter/cupertino.dart';
import 'package:tmbi/models/new_task/main_task_response.dart';
import 'package:tmbi/repo/new_task/task_details_repo.dart';

import '../../network/ui_state.dart';

class TaskDetailsViewmodel extends ChangeNotifier {
  final TaskDetailsRepo taskDetailsRepo;
  bool _disposed = false;

  TaskDetailsViewmodel({required this.taskDetailsRepo});

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  // --- API --- \\
  String? _message;

  String? get message => _message;

  MainTaskResponse? _mainTaskResponse;

  MainTaskResponse? get mainTaskResponse => _mainTaskResponse;

  List<SubTask> _subtasks = [];

  List<SubTask> get subtasks => _subtasks;

  bool? _isUpdated;

  bool? get isUpdated => _isUpdated;

  // UI state
  UiState _uiState = UiState.init;

  UiState get uiState => _uiState;

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
        _uiState = UiState.success;
      }
      else {
        _message = "Something went wrong, please try again.";
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

  /*await inquiryViewModel.updateTask(
            inquiryResponse.id.toString(),
            pair.first!.id.toString(),
            HomeFlagItem().priorities[3].id.toString(),
            "Successfully completed the task",
            widget.staffId,
            100, []);*/

  Future<void> updateTask(String inquiryId, String taskId, String priorityId,
      String description, String userId, int percentage, List<String> fileNames) async {
    if (_uiState == UiState.loading) return;

    _uiState = UiState.loading;
    _message = null;
    notifyListeners();
    try {
      final response = await taskDetailsRepo.updateTask(
          inquiryId, taskId, priorityId, description, userId, percentage, fileNames);
      _isUpdated = response;
      _uiState = UiState.success;
    } catch (error) {
      _uiState = UiState.error;
      _message = error.toString();
    } finally {
      notifyListeners();
    }
  }

}
