import 'package:flutter/cupertino.dart';
import 'package:tmbi/repo/repo.dart';

import '../models/models.dart';
import '../network/ui_state.dart';

class InquiryViewModel extends ChangeNotifier {
  final InquiryRepo inquiryRepo;

  InquiryViewModel({required this.inquiryRepo});

  /// message
  String? _message;

  String? get message => _message;

  /// inquiry list
  List<InquiryResponse>? _inquiries;

  List<InquiryResponse>? get inquiries => _inquiries;
  /// attachment list
  List<StringUrl>? _attachmentViewResponse;

  List<StringUrl>? get attachmentViewResponse => _attachmentViewResponse;

  /// note list
  List<Note>? _noteResponse;

  List<Note>? get noteResponse => _noteResponse;

  /// comment
  List<Discussion>? _commentResponse;

  List<Discussion>? get commentResponse => _commentResponse;

  /// save inquiry
  bool? _isSavedInquiry;

  bool? get isSavedInquiry => _isSavedInquiry;

  /// ui state
  UiState _uiState = UiState.init;

  UiState get uiState => _uiState;

  /// tab index
  int _tabSelectedFlag = 0;

  int get tabSelectedFlag => _tabSelectedFlag;

  set tabSelectedFlag(int value) {
    if (_tabSelectedFlag != value) {
      _tabSelectedFlag = value;
      notifyListeners(); // This will trigger a UI update
    }
  }


  /// report view flag
  bool _isOpenReportView = true;
  bool get isOpenReportView => _isOpenReportView;
  set isOpenReportView(bool value) {
    _isOpenReportView = value;
    notifyListeners();
  }

  Future<void> getInquiries(String flag, String userId, String isAssigned,
      {String vm = "INQALL"}) async {
      //{String vm = "INQALL_ALL"}) async {
    if (_uiState == UiState.loading) return;
    _message = null;
    _uiState = UiState.loading;
    notifyListeners();
    try {
      final response =
          await inquiryRepo.getInquiries(flag, userId, isAssigned, vm);
      //final response = _getDemoTasks(); // test purpose
      _inquiries = response;
      _uiState = UiState.success;
    } catch (error) {
      _uiState = UiState.error;
      _message = error.toString();
    } finally {
      notifyListeners();
    }
  }

  Future<void> getNotes(String inquiryId, String taskId) async {
    if (_uiState == UiState.loading) return;

    _uiState = UiState.loading;
    notifyListeners();
    try {
      final response = await inquiryRepo.getNotes(inquiryId, taskId);
      _noteResponse = response;
      _uiState = UiState.success;
    } catch (error) {
      _uiState = UiState.error;
      _message = error.toString();
    } finally {
      notifyListeners();
    }
  }

  Future<void> getAttachments(String inquiryId, String taskId) async {
    if (_uiState == UiState.loading) return;

    _uiState = UiState.loading;
    notifyListeners();
    try {
      final response = await inquiryRepo.getAttachments(inquiryId, taskId);
      _attachmentViewResponse = response;
      _uiState = UiState.success;
    } catch (error) {
      _uiState = UiState.error;
      _message = error.toString();
    } finally {
      notifyListeners();
    }
  }

  Future<void> getComments(String inquiryId, String taskId) async {
    if (_uiState == UiState.loading) return;

    _uiState = UiState.loading;
    notifyListeners();
    try {
      final response = await inquiryRepo.getComments(inquiryId, taskId);
      _commentResponse = response;
      _uiState = UiState.success;
    } catch (error) {
      _uiState = UiState.error;
      _message = error.toString();
    } finally {
      notifyListeners();
    }
  }

  Future<void> saveComment(
      String inquiryId, String body, String priorityId, String userId) async {
    if (_uiState == UiState.commentLoading) return;

    _uiState = UiState.commentLoading;
    notifyListeners();
    try {
      final response =
          await inquiryRepo.saveComment(inquiryId, body, priorityId, userId);
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
