import 'package:flutter/cupertino.dart' hide Notification;
import 'package:tmbi/models/new_task/notification_response.dart';
import 'package:tmbi/repo/new_task/notification_repo.dart';

import '../../network/ui_state.dart';

class NotificationViewmodel extends ChangeNotifier {
  final NotificationRepo notifRepo;
  bool _disposed = false;

  NotificationViewmodel({required this.notifRepo});

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  // --- API --- \\
  String? _message;

  String? get message => _message;

  List<Notification> _notificationList = [];

  List<Notification> get notificationList => _notificationList;

  // UI state
  UiState _uiState = UiState.init;

  UiState get uiState => _uiState;

  set uiState(UiState newState) {
    if (_uiState != newState) {
      _uiState = newState;
      notifyListeners();
    }
  }

  Future<void> getNotif(String staffId) async {
    if (_disposed) {
      return;
    }

    if (_uiState == UiState.loading) return;
    _uiState = UiState.loading;
    notifyListeners();
    try {
      final response = await notifRepo.getNotification(staffId);
      _notificationList = response;
      _uiState = UiState.success;
    } catch (error) {
      _uiState = UiState.error;
      _message = error.toString();
      debugPrint(_message);
    } finally {
      notifyListeners();
    }
  }
}
