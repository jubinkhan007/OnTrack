import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tmbi/config/palette.dart';
import 'package:tmbi/config/screen_config.dart';
import 'package:tmbi/network/api_service.dart';
import 'package:tmbi/repo/inquiry_repo.dart';
import 'package:tmbi/repo/login_repo.dart';
import 'package:tmbi/screens/screens.dart';
import 'package:tmbi/viewmodel/task_update_viewmodel.dart';

import 'config/router.dart';
import 'firebase_options.dart';
import 'viewmodel/viewmodel.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(const MyApp());
}

@pragma("vm:entry-point")
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  debugPrint(message.notification!.title.toString());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    //return LayoutBuilder(
    //builder: (context, constraints) {
    //SizeConfig().init(constraints);
    //SizeConfig.init2(context);
    ScreenConfig().init(context);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => LoginViewmodel(
            //loginRepo: LoginRepo(dio: ApiService().provideDio()),
            loginRepo: LoginRepo(
                dio: ApiService(
                        "https://ego.rflgroupbd.com:8077/ords/rpro/kickall/")
                    .provideDio()),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => InquiryCreateViewModel(
            inquiryRepo: InquiryRepo(
                //fileDio: ApiService().fileUploadDio(),
                fileDio: ApiService(
                        "https://ego.rflgroupbd.com:8077/ords/rpro/kickall/")
                    .fileUploadDio(),
                //dio: ApiService().provideDio()),
                dio: ApiService(
                        "https://ego.rflgroupbd.com:8077/ords/rpro/kickall/")
                    .provideDio()),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => AddTaskViewModel(
            inquiryRepo: InquiryRepo(
                //fileDio: ApiService().fileUploadDio(),
                fileDio: ApiService(
                        "https://ego.rflgroupbd.com:8077/ords/rpro/kickall/")
                    .fileUploadDio(),
                //dio: ApiService().provideDio()),
                dio: ApiService(
                        "https://ego.rflgroupbd.com:8077/ords/rpro/kickall/")
                    .provideDio()),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => InquiryViewModel(
            inquiryRepo: InquiryRepo(
                //fileDio: ApiService().fileUploadDio(),
                fileDio: ApiService(
                        "https://ego.rflgroupbd.com:8077/ords/rpro/kickall/")
                    .fileUploadDio(),
                //dio: ApiService().provideDio()),
                dio: ApiService(
                        "https://ego.rflgroupbd.com:8077/ords/rpro/kickall/")
                    .provideDio()),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => TodoViewModel(
            inquiryRepo: InquiryRepo(
                //fileDio: ApiService().fileUploadDio(),
                fileDio: ApiService(
                        "https://ego.rflgroupbd.com:8077/ords/rpro/kickall/")
                    .fileUploadDio(),
                //dio: ApiService().provideDio()),
                dio: ApiService(
                        "https://ego.rflgroupbd.com:8077/ords/rpro/kickall/")
                    .provideDio()),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => CommentViewModel(
            inquiryRepo: InquiryRepo(
                //fileDio: ApiService().fileUploadDio(),
                fileDio: ApiService(
                        "https://ego.rflgroupbd.com:8077/ords/rpro/kickall/")
                    .fileUploadDio(),
                //dio: ApiService().provideDio()),
                dio: ApiService(
                        "https://ego.rflgroupbd.com:8077/ords/rpro/kickall/")
                    .provideDio()),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => TaskUpdateViewModel(
            inquiryRepo: InquiryRepo(
                //fileDio: ApiService().fileUploadDio(),
                fileDio: ApiService(
                        "https://ego.rflgroupbd.com:8077/ords/rpro/kickall/")
                    .fileUploadDio(),
                //dio: ApiService().provideDio()),
                dio: ApiService(
                        "https://ego.rflgroupbd.com:8077/ords/rpro/kickall/")
                    .provideDio()),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => CounterViewModel(
            inquiryRepo: InquiryRepo(
                //fileDio: ApiService().fileUploadDio(),
                fileDio: ApiService(
                        "https://ego.rflgroupbd.com:8077/ords/rpro/kickall/")
                    .fileUploadDio(),
                //dio: ApiService().provideDio()),
                dio: ApiService(
                        "https://ego.rflgroupbd.com:8077/ords/rpro/kickall/")
                    .provideDio()),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => SettingsViewModel(),
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
          home: const LoginScreen()),
          //home: AuthCheck()),
      //home: const TodoHomeScreen()),
    );
  }
//);
}
