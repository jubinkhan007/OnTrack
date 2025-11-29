import 'package:flutter/material.dart';
import 'package:tmbi/repo/new_task/sign_up_repo.dart';

import '../../network/ui_state.dart';

class SignupViewmodel extends ChangeNotifier {
  final SignUpRepo signUpRepo;

  SignupViewmodel({required this.signUpRepo});

  String fullName = "";
  String email = "";
  String password = "";
  String confirmPassword = "";

  bool hidePassword = true;
  bool hideConfirmPassword = true;

  void togglePassword() {
    hidePassword = !hidePassword;
    notifyListeners();
  }

  void toggleConfirmPassword() {
    hideConfirmPassword = !hideConfirmPassword;
    notifyListeners();
  }

  void setFullName(String value) {
    fullName = value;
    notifyListeners();
  }

  void setEmail(String value) {
    email = value;
    notifyListeners();
  }

  void setPassword(String value) {
    password = value;
    notifyListeners();
  }

  void setConfirmPassword(String value) {
    confirmPassword = value;
    notifyListeners();
  }

  bool validate() {
    return fullName.isNotEmpty &&
        email.isNotEmpty &&
        password.isNotEmpty &&
        password.length >= 6 &&
        confirmPassword == password &&
        _isValidEmail(email);
  }

  bool _isValidEmail(String email) {
    String emailPattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$';
    RegExp regex = RegExp(emailPattern);
    return regex.hasMatch(email);
  }

  // --- API --- \\
  String? _message;

  String? get message => _message;

  bool? _isSuccess;

  bool? get isSuccess => _isSuccess;

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

  // Signup
  Future<void> signUp() async {
    if (_uiState == UiState.loading) return;
    _uiState = UiState.loading;
    notifyListeners();
    try {
      final response = await signUpRepo.signUp(
          "-1",
          "-1",
          "n/a",
          password,
          "0",
          "n/a",
          "-1",
          "-1",
          fullName,
          email,
          "[]");
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
