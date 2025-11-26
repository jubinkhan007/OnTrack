import 'package:flutter/material.dart';

class SignupViewmodel extends ChangeNotifier {
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
        confirmPassword == password;
  }
}
