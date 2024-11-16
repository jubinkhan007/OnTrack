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
      return MaterialPageRoute(
          settings: routeSettings, builder: (_) => const HomeScreen());
    case InquiryView.routeName:
      final args = routeSettings.arguments as InquiryResponse;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => InquiryView(
          inquiryResponse: args,
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
