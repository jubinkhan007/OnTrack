import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';

class NewTaskDashboardViewmodel extends ChangeNotifier {
  int pending = 15;
  int overdue = 5;
  int completed = 55;
  int selectedTab = 0; // 0=Created,1=Assigned, also used for All/Pending/etc.

  List<Map<String, String>> createdTasks = [
    {"title": "Q4 Marketing...", "staff": "Olivia Chen", "completion": "0% Complete"},
    {"title": "Website Redesign...", "staff": "Ben Carter", "completion": "0% Complete"},
  ];

  List<Map<String, String>> assignedTasks = [
    {"title": "Finalize Q3 Report", "staff": "Alex Johnson", "completion": "0% Complete"},
    {"title": "User Onboarding...", "staff": "Samantha Lee", "completion": "100% Complete"},
  ];

  void changeTab(int index) {
    selectedTab = index;
    notifyListeners();
  }

  List<Map<String, String>> get currentTasks =>
      selectedTab == 0 ? createdTasks : assignedTasks;


  String selectedBU = "All BU";
  List<String> buOptions = ["All BU", "BU1", "BU2", "BU3"];
  String staffName = "";

  void changeBU(String bu) {
    selectedBU = bu;
    notifyListeners();
  }

  void changeStaff(String staff) {
    staffName = staff;
    notifyListeners();
  }

}

