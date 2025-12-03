/*
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';

import '../../models/new_task/sub_task.dart';

class NewTaskDetailTaskViewmodel extends ChangeNotifier {
  late Task task;
  bool isLoading = true;

  /// Demo task list (fake API response)
  final List<Task> demoTasks = [
    Task(
      title: "Launch Marketing Campaign",
      assignee: "Alex Chen",
      dateRange: "Sep 1 - Sep 30",
      progress: 50,
      subtasks: [
        SubTask(
          title: "Design Social Media Graphics",
          assignee: "Maria Garcia",
          dateRange: "Sep 1 - Sep 15",
          progress: 100,
          completed: true,
        ),
        SubTask(
          title: "Write Ad Copy",
          assignee: "David Lee",
          dateRange: "Sep 14 - Sep 20",
          progress: 100,
          completed: true,
        ),
        SubTask(
          title: "UI Layout Design",
          assignee: "Ben Carter",
          dateRange: "Sep 14 - Oct 25",
          progress: 100,
          completed: true,
        ),
        SubTask(
          title: "API Integration",
          assignee: "Alice Johnson",
          dateRange: "Sep 14 - Sep 30",
          progress: 100,
          completed: true,
        ),
        SubTask(
          title: "User Authentication Setup",
          assignee: "John Doe",
          dateRange: "Sep 14 - Sep 30",
          progress: 0,
          completed: false,
        ),
        SubTask(
          title: "Database Schema Design",
          assignee: "Sara Lee",
          dateRange: "Sep 14 - Sep 30",
          progress: 0,
          completed: false,
        ),
        SubTask(
          title: "Mobile App Mockups",
          assignee: "Ben Carter",
          dateRange: "Sep 14 - Sep 30",
          progress: 0,
          completed: false,
        ),
        SubTask(
          title: "Testing & Debugging",
          assignee: "Emily Clark",
          dateRange: "Sep 14 - Sep 30",
          progress: 0,
          completed: false,
        ),
      ],
    ),
    Task(
      title: "Website Redesign",
      assignee: "Ben Carter",
      dateRange: "Oct 1 - Oct 30",
      progress: 20,
      subtasks: [
        SubTask(
          title: "Create Wireframes",
          assignee: "Hannah Kim",
          dateRange: "Oct 1 - Oct 10",
          progress: 100,
          completed: true,
        ),
        SubTask(
          title: "UI Layout Design",
          assignee: "Ben Carter",
          dateRange: "Oct 10 - Oct 20",
          progress: 40,
          completed: false,
        ),
      ],
    ),
    Task(
      title: "HR Recruitment Drive",
      assignee: "Sophie Martinez",
      dateRange: "Aug 10 - Sep 12",
      progress: 70,
      subtasks: [
        SubTask(
          title: "Post Job Ads",
          assignee: "John Doe",
          dateRange: "Aug 10 - Aug 15",
          progress: 100,
          completed: true,
        ),
      ],
    ),
  ];

  /// Constructor receives which index to load
  */
/*NewTaskDetailTaskViewmodel({required int index}) {
    task = demoTasks[index];
    _load();                   // auto load
  }

  Future<void> _load() async {
    await Future.delayed(const Duration(milliseconds: 400)); // simulate API delay
    isLoading = false;
    notifyListeners();
  }*//*


  NewTaskDetailTaskViewmodel({required int index}) {
    _load(index);
  }

  Future<void> _load(int index) async {
    await Future.delayed(const Duration(milliseconds: 300));

    task = demoTasks[index]; // <-- From your mock list

    isLoading = false;
    notifyListeners();
  }
}
*/
