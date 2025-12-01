import 'package:flutter/cupertino.dart';
import 'package:tmbi/db/dao/sync_dao.dart';
import 'package:tmbi/models/new_task/bu_response.dart';
import 'package:tmbi/repo/new_task/sync_repo.dart';

import '../../db/db_constant.dart';
import '../../network/ui_state.dart';

class SyncViewmodel extends ChangeNotifier {
  final SyncRepo syncRepo;
  final String staffId;
  final SyncDao syncDao = SyncDao();

  bool _disposed = false;

  SyncViewmodel({required this.staffId,  required this.syncRepo}) {
    getStaffs(staffId);
  }


  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  // --- API --- \\
  String? _message;

  String? get message => _message;

  BuResponse? _buResponse;

  BuResponse? get buResponse => _buResponse;

  // UI state
  UiState _uiState = UiState.init;

  UiState get uiState => _uiState;

  set uiState(UiState newState) {
    if (_uiState != newState) {
      // only notify if the state has actually changed
      _uiState = newState;
      notifyListeners();
    }
  }

  // --- Progress ---
  double _progressPercent = 0.0;
  double get progressPercent => _progressPercent;

  //int _savedItems = 0;
  //int get savedItems => _savedItems;

  Future<void> getStaffs(String staffId) async {
    if (_disposed) {
      return; // Do nothing if the ViewModel is disposed.
    }

    if (_uiState == UiState.loading) return;
    _uiState = UiState.loading;
    notifyListeners();
    try {
      final response = await syncRepo.getStuffs(staffId);
      _buResponse = response;
      _uiState = UiState.success;
      await _saveStaffsInDB(response.bu);
    } catch (error) {
      _uiState = UiState.error;
      _message = error.toString();
      debugPrint(_message);
    } finally {
      notifyListeners();
    }
  }


  Future<void> _saveStaffsInDB(List<BusinessUnit> buList) async {
    await syncDao.deleteTable(DBConstant.tableStaff);

    await syncDao.insertStaffsBatch(buList, (percent) {
      _progressPercent = percent;
      notifyListeners();
    });

  }


}
