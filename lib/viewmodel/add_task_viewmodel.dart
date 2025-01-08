import 'package:flutter/cupertino.dart';

import '../models/models.dart';
import '../network/ui_state.dart';
import '../repo/repo.dart';

class AddTaskViewModel extends ChangeNotifier {
  final InquiryRepo inquiryRepo;

  AddTaskViewModel({required this.inquiryRepo});

  /// ui state
  UiState _uiState = UiState.init;

  UiState get uiState => _uiState;

  /// message
  String? _message;

  String? get message => _message;

  /// staff
  StaffResponse? _staffResponse;

  StaffResponse? get staffResponse => _staffResponse;

  // clear tasks
  removeTasks() {
    if (_staffResponse != null) {
      if (_staffResponse!.staffs != null) {
       if (_staffResponse!.staffs!.isNotEmpty){
         _staffResponse!.staffs!.clear();
       }
      }
    }
  }

  Future<void> getStaffs(String staffId, String companyId, {String vm = "STAFF"}) async {
    if (_uiState == UiState.loading) return;

    _uiState = UiState.loading;
    notifyListeners();
    try {
      final response = await inquiryRepo.getStaffs(staffId, companyId, vm);
      _staffResponse = response;
      _uiState = UiState.success;
    } catch (error) {
      _uiState = UiState.error;
      _message = error.toString();
      // set null if any exception
      _staffResponse = null;
    } finally {
      notifyListeners();
    }
  }
}
