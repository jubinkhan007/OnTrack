import 'package:flutter/material.dart';
import 'package:tmbi/screens/new_task/task_deatil_screen.dart';

class AppNavigator {
  static final GlobalKey<NavigatorState> key = GlobalKey<NavigatorState>();

  static Future<void> openTaskDetails({
    required String staffId,
    required String taskId,
    String assignName = "You",
  }) async {
    Future<void> pushOn(NavigatorState nav) async {
      await nav.push(
        MaterialPageRoute(
          builder: (_) => TaskDetailsScreen(
            index: 0,
            assignName: assignName,
            taskId: taskId,
            staffId: staffId,
          ),
        ),
      );
    }

    final nav = key.currentState;
    if (nav != null) {
      await pushOn(nav);
      return;
    }

    // App may have been launched from a notification before the widget tree
    // is ready. Try again after the first frame.
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final nav2 = key.currentState;
      if (nav2 == null) return;
      await pushOn(nav2);
    });
  }
}
