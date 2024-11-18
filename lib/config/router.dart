import 'package:flutter/material.dart';
import 'package:tmbi/models/models.dart';

import '../screens/screens.dart';

Route<dynamic> generateRoute(RouteSettings routeSettings) {
  switch (routeSettings.name) {
    case IntroScreen.routeName:
      return MaterialPageRoute(
          settings: routeSettings, builder: (_) => const LoginScreen());
    case LoginScreen.routeName:
      return MaterialPageRoute(
          settings: routeSettings, builder: (_) => const LoginScreen());
    case HomeScreen.routeName:
      final args = routeSettings.arguments as String;
      return MaterialPageRoute(
          settings: routeSettings, builder: (_) => HomeScreen(staffId: args,));
    case InquiryView.routeName:
      /*final args = routeSettings.arguments as InquiryResponse;
      final args1 = routeSettings.arguments as String;*/
      final arguments = routeSettings.arguments as Map<String, dynamic>;
      final inquiryResponse = arguments['inquiryResponse'] as InquiryResponse;
      final flag = arguments['flag'] as String;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => InquiryView(
          inquiryResponse: inquiryResponse,
          flag: flag,
        ),
      );
    case CreateInquiryScreen.routeName:
      return MaterialPageRoute(
          settings: routeSettings, builder: (_) => const CreateInquiryScreen());
    case CommentScreen.routeName:
      final args = routeSettings.arguments as String;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => CommentScreen(
          commentId: args,
        ),
      );
    case AttachmentViewScreen.routeName:
      final args = routeSettings.arguments as String;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => AttachmentViewScreen(
          attachmentId: args,
        ),
      );
    case NoteScreen.routeName:
      //final args = routeSettings.arguments as String;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const NoteScreen(),
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
