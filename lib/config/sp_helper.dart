import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:tmbi/models/user_response.dart';

class SPHelper {
  static const String _userKey = 'sp_user_key';

  // Private static instance of the class
  static final SPHelper _instance = SPHelper._internal();

  // Private constructor to prevent direct instantiation
  SPHelper._internal();

  // Factory constructor to return the single instance
  factory SPHelper() {
    return _instance;
  }

  // Save the user data to SharedPreferences
  Future<void> saveUser(UserResponse userResponse) async {
    final prefs = await SharedPreferences.getInstance();
    String userJson = jsonEncode(userResponse.toJson()); // Convert UserResponse to JSON
    await prefs.setString(_userKey, userJson);
  }

  // Get the user data from SharedPreferences
  Future<UserResponse?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    String? userJson = prefs.getString(_userKey);
    if (userJson != null) {
      Map<String, dynamic> userMap = jsonDecode(userJson); // Convert JSON string to map
      return UserResponse.fromJson(userMap);
    }
    return null; // Return null if no user data is found
  }

  // Remove the user data from SharedPreferences
  Future<void> removeUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey); // Remove the user data
  }
}
