import 'package:flutter/cupertino.dart';
import 'package:tmbi/repo/inquiry_repo.dart';

import '../models/models.dart';
import '../network/ui_state.dart';

class InquiryViewModel extends ChangeNotifier {
  final InquiryRepo inquiryRepo;

  InquiryViewModel({required this.inquiryRepo});

  /// message
  String? _message;

  String? get message => _message;

  /// init data for creating inquiry
  InitDataCreateInq? _initDataCreateInq;

  InitDataCreateInq? get initDataCreateInq => _initDataCreateInq;

  /// inquiry list
  List<InquiryResponse>? _inquiries;

  List<InquiryResponse>? get inquiries => _inquiries;

  /// ui state
  UiState _uiState = UiState.init;

  UiState get uiState => _uiState;

  Future<void> getInitDataForCreateInquiry() async {
    if (_uiState == UiState.loading) return;

    _uiState = UiState.loading;
    notifyListeners();
    try {
      final response = await inquiryRepo.getInitDataForCreateInquiry();
      _initDataCreateInq = response;
      _uiState = UiState.success;
    } catch (error) {
      _uiState = UiState.error;
      _message = error.toString();
    } finally {
      notifyListeners();
    }
  }

  Future<void> getInquiries() async {
    if (_uiState == UiState.loading) return;

    _uiState = UiState.loading;
    notifyListeners();
    try {
      final response = await inquiryRepo.getInquiries();
      _inquiries = response;
      _uiState = UiState.success;
    } catch (error) {
      _uiState = UiState.error;
      _message = error.toString();
    } finally {
      notifyListeners();
    }
  }

}
