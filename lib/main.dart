import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tmbi/config/palette.dart';
import 'package:tmbi/network/api_service.dart';
import 'package:tmbi/repo/login_repo.dart';
import 'package:tmbi/screens/screens.dart';
import 'package:tmbi/viewmodel/login_viewmodel.dart';

import 'config/router.dart';
import 'config/size_config.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        SizeConfig().init(constraints);
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(
              create: (_) => LoginViewmodel(
                loginRepo: LoginRepo(dio: ApiService().provideDio()),
              ),
            ),
          ],
          child: MaterialApp(
            title: 'Kick Track',
            debugShowCheckedModeBanner: false,
            onGenerateRoute: (settings) => generateRoute(settings),
            theme: ThemeData(
                colorScheme: ColorScheme.fromSeed(seedColor: Palette.mainColor),
                useMaterial3: true,
                scaffoldBackgroundColor: Palette.scaffold),
            home: /*const IntroScreen()*/ /*const LoginScreen()*/
                const LoginScreen(),
          ),
        );
      },
    );
  }
}
