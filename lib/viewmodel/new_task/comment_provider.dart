import 'package:flutter/material.dart';
import 'package:tmbi/models/new_task/comment_response.dart';

import '../../network/ui_state.dart';
import '../../repo/new_task/comment_repo.dart';

class CommentProvider extends ChangeNotifier {

  final TextEditingController commentController = TextEditingController();
  final CommentRepo commentRepo;
  final String staffId;
  final String inqId;

  bool _disposed = false;

  CommentProvider(this.staffId, this.inqId, {required this.commentRepo}) {
    getComments(staffId, inqId, "");
  }

  @override
  void dispose() {
    _disposed = true;
    commentController.dispose();
    super.dispose();
  }

  // --- API --- \\
  String? _message;

  String? get message => _message;

  List<Comment> _commentList = [];

  List<Comment> get commentList => _commentList;

  bool? _isSuccess;

  bool? get isSuccess => _isSuccess;

  // UI state
  UiState _uiState = UiState.init;

  UiState get uiState => _uiState;

  set uiState(UiState newState) {
    if (_uiState != newState) {
      _uiState = newState;
      notifyListeners();
    }
  }

  Future<void> refresh(
    String staffId,
    String inquiryId,
    String taskId,
  ) async {
    try {
      final response = await commentRepo.getComments(
        staffId,
        inquiryId,
        taskId,
      );

      _commentList
        ..clear()
        ..addAll(response);

      notifyListeners();
    } catch (e) {
      debugPrint("GET COMMENTS ERROR: $e");
    }
  }

  Future<void> getComments(
    String staffId,
    String inqId,
    String taskId,
  ) async {
    if (_uiState == UiState.loading) return;

    _uiState = UiState.loading;
    notifyListeners();

    try {
      final response = await commentRepo.getComments(
        staffId,
        inqId,
        taskId,
      );

      _commentList
        ..clear()
        ..addAll(response);
      //_commentList.clear();
      //_commentList.addAll(response);

      _uiState = UiState.success;
    } catch (error) {
      _uiState = UiState.error;
      _message = error.toString();
    } finally {
      notifyListeners();
    }
  }

  Future<void> saveComment(String inquiryId, String userId) async {
    final text = commentController.text.trim();
    if (text.isEmpty) return;

    if (_uiState == UiState.loading) return;
    _uiState = UiState.loading;
    notifyListeners();
    try {
      final response = await commentRepo.saveComment(inquiryId, text, userId);
      debugPrint("ID: $userId, InqId: $inquiryId");
      if (response) {
        commentController.clear();
        await refresh(userId, inquiryId, "");
      }

      _isSuccess = response;
      _uiState = UiState.success;
    } catch (error) {
      _uiState = UiState.error;
      _message = error.toString();
    } finally {
      notifyListeners();
    }
  }
}
