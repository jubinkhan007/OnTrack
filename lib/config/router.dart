import 'package:flutter/material.dart';
import 'package:tmbi/models/models.dart';

import '../screens/new_task/card_scan_screen.dart';
import '../screens/new_task/notification_screen.dart';
import '../screens/new_task/dashboard_screen.dart';
import '../screens/new_task/signup_screen.dart';
import '../screens/new_task/sync_screen.dart';
import '../screens/new_task/task_deatil_screen.dart';
import '../screens/screens.dart';
import '../screens/todo/todo_home_screen.dart';

PageRouteBuilder<T> _buildAppRoute<T>({
  required RouteSettings settings,
  required WidgetBuilder builder,
}) {
  return PageRouteBuilder<T>(
    settings: settings,
    transitionDuration: const Duration(milliseconds: 260),
    reverseTransitionDuration: const Duration(milliseconds: 220),
    pageBuilder: (context, animation, secondaryAnimation) => builder(context),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final curved = CurvedAnimation(parent: animation, curve: Curves.easeOut);
      final fade = FadeTransition(opacity: curved, child: child);

      final offsetTween = Tween<Offset>(
        begin: const Offset(0.02, 0),
        end: Offset.zero,
      ).chain(CurveTween(curve: Curves.easeOutCubic));

      return SlideTransition(position: animation.drive(offsetTween), child: fade);
    },
  );
}

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
    case DashboardScreen.routeName:
      return MaterialPageRoute(
          settings: routeSettings, builder: (_) => const DashboardScreen());*/
    /*case NotificationScreen.routeName:
      return MaterialPageRoute(
          settings: routeSettings, builder: (_) => const NotificationScreen());
    */
    case TodoHomeScreen.routeName:
      final args = routeSettings.arguments as String;
      return _buildAppRoute(
        settings: routeSettings,
        builder: (_) => TodoHomeScreen(staffId: args),
      );
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
      final args = routeSettings.arguments;
      final String staffId;
      if (args is String) {
        staffId = args;
      } else if (args is Map<String, dynamic>) {
        staffId = (args['staffId'] ?? '') as String;
      } else {
        staffId = '';
      }

      return _buildAppRoute(
        settings: routeSettings,
        builder: (_) => SyncScreen.create(staffId),
      );
    /*case CardScanScreen.routeName:
      final args = routeSettings.arguments as String;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => CardScanScreen(
          staffId: args,
        ),
      );*/
    case NotificationScreen2.routeName:
      final args = routeSettings.arguments as String;
      return _buildAppRoute(
        settings: routeSettings,
        builder: (_) => NotificationScreen2(staffId: args),
      );
    case NewTaskDashboardScreen.routeName:
      //final args = routeSettings.arguments as String;
      final args = routeSettings.arguments as Map<String, dynamic>;

      final String staffId = args['staffId'];
      final String staffName = args['name'];

      return _buildAppRoute(
        settings: routeSettings,
        builder: (_) => NewTaskDashboardScreen.create(staffId, staffName),
      );
    case TaskDetailsScreen.routeName:
      final args = routeSettings.arguments;
      if (args is Map<String, dynamic>) {
        return _buildAppRoute(
          settings: routeSettings,
          builder: (_) => TaskDetailsScreen(
            index: (args['index'] ?? 0) as int,
            assignName: (args['assignName'] ?? '') as String,
            taskId: (args['taskId'] ?? '') as String,
            staffId: (args['staffId'] ?? '') as String,
          ),
        );
      }
      return _buildAppRoute(
        settings: routeSettings,
        builder: (_) => const Scaffold(
          body: Center(child: Text('Invalid TaskDetails args')),
        ),
      );
    case SignupScreen.routeName:
      return _buildAppRoute(
        settings: routeSettings,
        builder: (_) => SignupScreen.create(),
      );
    case DashboardScreen.routeName:
      return _buildAppRoute(
        settings: routeSettings,
        builder: (_) => DashboardScreen.create('', []),
      );
    default:
      return _buildAppRoute(
        settings: routeSettings,
        builder: (_) => const Scaffold(
          body: Center(
            child: Text('Screen does not exist!'),
          ),
        ),
      );
  }
}
