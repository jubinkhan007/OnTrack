import 'package:flutter/cupertino.dart';

import '../models/image_file.dart';
import '../network/ui_state.dart';
import '../repo/repo.dart';

class TaskUpdateViewModel extends ChangeNotifier {
  final InquiryRepo inquiryRepo;

  TaskUpdateViewModel({required this.inquiryRepo});

  /// message
  String? _message;

  String? get message => _message;

  /// ui state
  UiState _uiState = UiState.init;

  UiState get uiState => _uiState;

  /// save inquiry
  bool? _isSavedInquiry;

  bool? get isSavedInquiry => _isSavedInquiry;

  /// image files
  final List<ImageFile> _imageFiles = [];

  List<ImageFile> get imageFiles => _imageFiles;

  void addImageFiles(List<ImageFile> files) {
    _imageFiles.addAll(files);
  }

  void removeImageFiles() {
    if (_imageFiles.isNotEmpty) {
      _imageFiles.clear();
    }
  }

  /// file names
  final List<String> _files = [];

  List<String> get files => _files;

  removeFiles() {
    if (_files.isNotEmpty) {
      _files.clear();
    }
  }

  /// description
  String? _description;

  String? get description => _description;

  void setDescription(String value) {
    _description = value;
  }

  /// STATUS
  String? _status;

  String? get status => _status;

  String? _statusName;

  String? get statusName => _statusName;

  void addStatus(String value) {
    _status = value;
  }

  void addStatusName(String value) {
    _statusName = value;
  }

  Future<void> saveFiles(
    List<ImageFile> files,
  ) async {
    if (_uiState == UiState.loading) return;

    _uiState = UiState.loading;
    notifyListeners();
    try {
      final response = await inquiryRepo.saveImages(files);
      if (response != null && response is List) {
        for (var name in response) {
          if (name is Map<String, dynamic> && name.containsKey('FileName')) {
            _files.add(name['FileName']);
          }
        }
      }
      _uiState = UiState.success;
    } catch (error) {
      _uiState = UiState.error;
      _message = error.toString();
    } finally {
      notifyListeners();
    }
  }

  Future<void> updateTask(
      String inquiryId,
      String taskId,
      String priorityId,
      String description,
      String userId,
      int percentage,
      List<String> fileNames) async {
    if (_uiState == UiState.loading) return;

    _uiState = UiState.loading;
    notifyListeners();
    try {
      final response = await inquiryRepo.updateTask(inquiryId, taskId,
          priorityId, description, userId, percentage, fileNames);
      _isSavedInquiry = response;
      _uiState = UiState.success;
    } catch (error) {
      _uiState = UiState.error;
      _message = error.toString();
    } finally {
      notifyListeners();
    }
  }

  Future<void> editTask(String inquiryId, String taskId, String isUpdateToAll,
      String newTask, String userId, List<String> fileNames) async {
    if (_uiState == UiState.loading) return;

    _uiState = UiState.loading;
    notifyListeners();
    try {
      final response = await inquiryRepo.editTask(
          inquiryId, taskId, isUpdateToAll, newTask, userId, fileNames);
      _isSavedInquiry = response;
      _uiState = UiState.success;
    } catch (error) {
      _uiState = UiState.error;
      _message = error.toString();
    } finally {
      notifyListeners();
    }
  }

  Future<void> updateEmailMob(
      String email, String mobileNo, String userId) async {
    if (_uiState == UiState.loading) return;

    _uiState = UiState.loading;
    notifyListeners();
    try {
      final response = await inquiryRepo.editEmailMob(mobileNo, email, userId);
      _isSavedInquiry = response;
      _uiState = UiState.success;
    } catch (error) {
      _uiState = UiState.error;
      _message = error.toString();
    } finally {
      notifyListeners();
    }
  }

  Future<void> updateExpireDate(
      String inquiryId,
      String taskId,
      String priorityId,
      String date,
      String userId,
      List<String> fileNames) async {
    if (_uiState == UiState.loading) return;

    _uiState = UiState.loading;
    notifyListeners();
    try {
      final response = await inquiryRepo.updateExpireDate(
          inquiryId, taskId, priorityId, date, userId, fileNames);
      _isSavedInquiry = response;
      _uiState = UiState.success;
    } catch (error) {
      _uiState = UiState.error;
      _message = error.toString();
    } finally {
      notifyListeners();
    }
  }

  Future<void> forwardTask(String inquiryId, String taskId, String priorityId,
      String fUserId, String userId, List<String> fileNames) async {
    if (_uiState == UiState.loading) return;

    _uiState = UiState.loading;
    notifyListeners();
    try {
      final response = await inquiryRepo.forwardTask(
          inquiryId, taskId, priorityId, fUserId, userId, fileNames);
      _isSavedInquiry = response;
      _uiState = UiState.success;
    } catch (error) {
      _uiState = UiState.error;
      _message = error.toString();
    } finally {
      notifyListeners();
    }
  }
}
