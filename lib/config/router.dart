import 'package:flutter/material.dart';
import 'package:tmbi/data/inquiry_response.dart';

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
