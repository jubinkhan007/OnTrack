import 'package:flutter/material.dart';
import 'package:tmbi/models/models.dart';

import '../screens/new_task/card_scan_screen.dart';
import '../screens/new_task/notification_screen.dart';
import '../screens/new_task/signup_screen.dart';
import '../screens/new_task/sync_screen.dart';
import '../screens/new_task/task_deatil_screen.dart';
import '../screens/screens.dart';
import '../screens/todo/todo_home_screen.dart';

Route<dynamic> generateRoute(RouteSettings routeSettings) {
  switch (routeSettings.name) {
    /*case IntroScreen.routeName:
      return MaterialPageRoute(
          settings: routeSettings, builder: (_) => const LoginScreen());*/
    /*case LoginScreen.routeName:
      return MaterialPageRoute(
          settings: routeSettings, builder: (_) => const LoginScreen());
    case HomeScreen.routeName:
      final args = routeSettings.arguments as String;
      return MaterialPageRoute(
          settings: routeSettings,
          builder: (_) => HomeScreen(
                staffId: args,
              ));
    case SettingScreen.routeName:
      return MaterialPageRoute(
          settings: routeSettings, builder: (_) => const SettingScreen());
    case ReportScreen.routeName:
      return MaterialPageRoute(
          settings: routeSettings, builder: (_) => const ReportScreen());*/
    /*case NotificationScreen.routeName:
      return MaterialPageRoute(
          settings: routeSettings, builder: (_) => const NotificationScreen());
    */
    case TodoHomeScreen.routeName:
      final args = routeSettings.arguments as String;
      return MaterialPageRoute(
          settings: routeSettings,
          builder: (_) => TodoHomeScreen(
                staffId: args,
              ));
    /*case InquiryView.routeName:
      /*final args = routeSettings.arguments as InquiryResponse;
      final args1 = routeSettings.arguments as String;*/
      final arguments = routeSettings.arguments as Map<String, dynamic>;
      final inquiryResponse = arguments['inquiryResponse'] as InquiryResponse;
      final flag = arguments['flag'] as String;
      final staffId = arguments['staffId'] as String;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => InquiryView(
            inquiryResponse: inquiryResponse, flag: flag, staffId: staffId),
      );
    case CreateInquiryScreen.routeName:
      final args = routeSettings.arguments as String;
      return MaterialPageRoute(
          settings: routeSettings,
          builder: (_) => CreateInquiryScreen(
                staffId: args,
              ));
    case AddTaskToStaffScreen.routeName:
      final args = routeSettings.arguments as Map<String, dynamic>;
      final staffId = args['staffId'] as String;
      final description = args['description'] as String;
      final companyId = args['companyId'] as String;
      final List<Discussion> tasks = (args['individual_task'] as List)
          .map((taskJson) =>
              Discussion.fromJson(taskJson as Map<String, dynamic>))
          .toList();
      /*final List<Staff> staffs = (args['staff_list'] as List)
          .map((taskJson) => Staff.fromJson(taskJson as Map<String, dynamic>))
          .toList();*/
      return MaterialPageRoute(
          settings: routeSettings,
          builder: (_) => AddTaskToStaffScreen(
                staffId: staffId,
                companyId: companyId,
                tasks: tasks,
                initDescription: description,
                //: staffs,
              ));
    case CommentScreen.routeName:
      final args = routeSettings.arguments as String;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => CommentScreen(
          inquiryId: args,
        ),
      );
    case AttachmentViewScreen.routeName:
      final arguments = routeSettings.arguments as Map<String, dynamic>;
      final inquiryId = arguments['inquiryId'] as String;
      final taskId = arguments['taskId'] as String;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => AttachmentViewScreen(
          inquiryId: inquiryId,
          taskId: taskId,
        ),
      );
    case NoteScreen.routeName:
      final arguments = routeSettings.arguments as Map<String, dynamic>;
      final inquiryId = arguments['inquiryId'] as String;
      final taskId = arguments['taskId'] as String;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => NoteScreen(
          inquiryId: inquiryId,
          taskId: taskId,
        ),
      );*/

    /// NEW HOME \\\
    case SyncScreen.routeName:
      final args = routeSettings.arguments as String;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => SyncScreen.create(args),
      );
    case CardScanScreen.routeName:
      final args = routeSettings.arguments as String;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => CardScanScreen(
          staffId: args,
        ),
      );
    case NotificationScreen2.routeName:
      final args = routeSettings.arguments as String;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => NotificationScreen2(
          staffId: args,
        ),
      );
    case NewTaskDashboardScreen.routeName:
      final args = routeSettings.arguments as String;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => NewTaskDashboardScreen.create(args),
      );
    case TaskDetailsScreen.routeName:
      final assignName = routeSettings.arguments as String;
      final index = routeSettings.arguments as int;
      final taskId = routeSettings.arguments as String;
      final staffId = routeSettings.arguments as String;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => TaskDetailsScreen(
          index: index,
          assignName: assignName,
          taskId: taskId,
          staffId: staffId,
        ),
      );
    case SignupScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => SignupScreen.create(),
      );
    default:
      return MaterialPageRoute(
          settings: routeSettings,
          builder: (_) => const Scaffold(
                body: Center(
                  child: Text('Screen does not exist!'),
                ),
              ));
  }
}
