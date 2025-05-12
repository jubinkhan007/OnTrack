import 'package:flutter/cupertino.dart';

import '../models/models.dart';
import '../models/searched_staff_response.dart';
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

  /// search staff
  SearchedStaffResponse? _searchedStaffResponse;

  SearchedStaffResponse? get searchedStaffResponse => _searchedStaffResponse;

  String? _decoText;
  String? get decoText => _decoText;

  bool? _isSavedStaff;

  bool? get isSavedStaff => _isSavedStaff;


  // clear tasks
  removeTasks() {
    if (_staffResponse != null) {
      if (_staffResponse!.staffs != null) {
        if (_staffResponse!.staffs!.isNotEmpty) {
          _staffResponse!.staffs!.clear();
        }
      }
    }
  }

  Future<void> getStaffs(String staffId, String companyId,
      {String vm = "STAFF"}) async {
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

  Future<void> searchStaffs(String staffId, {String vm = "NEWSTAFF"}) async {
    if (_uiState == UiState.loading) return;

    _uiState = UiState.loading;
    resetSearchStaffs();
    notifyListeners();
    try {
      final response = await inquiryRepo.searchStaff(staffId, vm);
      _searchedStaffResponse = response;
      if (_searchedStaffResponse != null) {
        if (_searchedStaffResponse!.staffs != null) {
          if (_searchedStaffResponse!.staffs!.isNotEmpty) {
            _decoText ="Staff Info:${_searchedStaffResponse!.staffs![0].name!} [${_searchedStaffResponse!.staffs![0].code!}]\n"
                "${_searchedStaffResponse!.staffs![0].designation!}, ${_searchedStaffResponse!.staffs![0].department!}";
          }
        }
      }
      _uiState = UiState.success;
    } catch (error) {
      _uiState = UiState.error;
      _message = error.toString();
      // set null if any exception
      _searchedStaffResponse = null;
      _decoText = null;
    } finally {
      notifyListeners();
    }
  }

  void setMessage(String message) {
    _message = message;
    notifyListeners();
  }


  Future<void> saveSearchedStaff(String userId) async {
    if (_uiState == UiState.commentLoading) return;

    _uiState = UiState.commentLoading;
    _message = null;
    notifyListeners();
    try {
      final response =
      await inquiryRepo.saveSearchedStaff(_searchedStaffResponse!.staffs![0], userId);
      _isSavedStaff = response;
      _uiState = UiState.success;
    } catch (error) {
      _uiState = UiState.error;
      _message = error.toString();
    } finally {
      notifyListeners();
    }
  }

  resetSearchStaffs() {
    _searchedStaffResponse = null;
    _decoText = null;
    _message = null;
  }

}
