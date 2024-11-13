import 'package:flutter/cupertino.dart';
import 'package:tmbi/repo/inquiry_repo.dart';

import '../network/ui_state.dart';

class CounterViewModel extends ChangeNotifier {
  final InquiryRepo inquiryRepo;

  CounterViewModel({required this.inquiryRepo});

  /// message
  String? _message;

  String? get message => _message;

  /// inquiry list
  String? _counter;

  String? get counter => _counter;

  /// ui state
  UiState _uiState = UiState.init;

  UiState get uiState => _uiState;

  Future<void> getCount() async {
    if (_uiState == UiState.loading) return;
    _uiState = UiState.loading;
    notifyListeners();
    try {
      final response = await inquiryRepo.getCount();
      _counter = response;
      _uiState = UiState.success;
    } catch (error) {
      _uiState = UiState.error;
      _message = error.toString();
    } finally {
      notifyListeners();
    }
  }
}
