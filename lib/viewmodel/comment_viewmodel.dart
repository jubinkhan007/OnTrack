

import 'package:flutter/cupertino.dart';

import '../models/models.dart';
import '../network/ui_state.dart';
import '../repo/repo.dart';

class CommentViewModel extends ChangeNotifier {
  final InquiryRepo inquiryRepo;

  CommentViewModel({required this.inquiryRepo});

  /// ui state
  UiState _uiState = UiState.init;

  UiState get uiState => _uiState;

  /// message
  String? _message;

  String? get message => _message;

  /// comment
  List<Discussion>? _commentResponse;

  List<Discussion>? get commentResponse => _commentResponse;

  /// save inquiry
  bool? _isSavedInquiry;

  bool? get isSavedInquiry => _isSavedInquiry;

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