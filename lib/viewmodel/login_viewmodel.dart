import 'package:flutter/cupertino.dart';
import 'package:tmbi/models/user_response.dart';
import 'package:tmbi/network/ui_state.dart';
import 'package:tmbi/repo/login_repo.dart';

class LoginViewmodel extends ChangeNotifier {
  final LoginRepo loginRepo;

  LoginViewmodel({required this.loginRepo});

  /// message
  String? _message;

  String? get message => _message;

  /// user
  UserResponse? _userResponse;

  UserResponse? get userResponse => _userResponse;

  /// ui state
  UiState _uiState = UiState.init;

  UiState get uiState => _uiState;

  // user validation check using ID and password
  Future<void> userAuth(String userId, String password, String? firebaseDeviceToken) async {
    _uiState = UiState.loading;
    notifyListeners();
    try {
      final response = await loginRepo.userAuth(userId, password, firebaseDeviceToken);
      _userResponse = response;
      _uiState = UiState.success;
      notifyListeners();
    } catch (error) {
      _uiState = UiState.error;
      _message = error.toString();
      notifyListeners();
    }
  }
}
