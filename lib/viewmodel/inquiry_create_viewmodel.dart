import 'package:flutter/cupertino.dart';
import 'package:tmbi/repo/inquiry_repo.dart';

import '../models/models.dart';
import '../network/ui_state.dart';
import '../widgets/file_attachment.dart';

class InquiryCreateViewModel extends ChangeNotifier {
  final InquiryRepo inquiryRepo;

  InquiryCreateViewModel({required this.inquiryRepo});

  /// message
  String? _message;

  String? get message => _message;

  /// init data for creating inquiry
  InitDataCreateInq? _initDataCreateInq;

  InitDataCreateInq? get initDataCreateInq => _initDataCreateInq;

  /// file names
  List<String> _files = [];

  List<String> get files => _files;

  /// save inquiry
  bool? _isSavedInquiry;

  bool? get isSavedInquiry => _isSavedInquiry;

  /// ui state
  UiState _uiState = UiState.init;

  UiState get uiState => _uiState;

  Future<void> getInitDataForCreateInquiry(String staffId) async {
    if (_uiState == UiState.loading) return;

    _uiState = UiState.loading;
    notifyListeners();
    try {
      final response = await inquiryRepo.getInitDataForCreateInquiry(staffId);
      _initDataCreateInq = response;
      _uiState = UiState.success;
    } catch (error) {
      _uiState = UiState.error;
      _message = error.toString();
    } finally {
      notifyListeners();
    }
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

  Future<void> saveInquiry(
      String companyId,
      String inquiryId,
      String inquiryName,
      String inquiryDesc,
      String isSample,
      String neededDate,
      String priorityId,
      String customerId,
      String customerName,
      String userId,
      List<String> fileNames) async {
    if (_uiState == UiState.loading) return;

    _uiState = UiState.loading;
    notifyListeners();
    try {
      final response = await inquiryRepo.saveInquiry(
          companyId,
          inquiryId,
          inquiryName,
          inquiryDesc,
          isSample,
          neededDate,
          priorityId,
          customerId,
          customerName,
          userId,
          fileNames);
      _isSavedInquiry = response;
      _uiState = UiState.success;
    } catch (error) {
      _uiState = UiState.error;
      _message = error.toString();
    } finally {
      notifyListeners();
    }
  }

  Future<void> updateTask(String inquiryId, String taskId, String priorityId,
      String description, String userId, List<String> fileNames) async {
    if (_uiState == UiState.loading) return;

    _uiState = UiState.loading;
    notifyListeners();
    try {
      final response = await inquiryRepo.updateTask(
          inquiryId, taskId, priorityId, description, userId, fileNames);
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
