import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tmbi/config/extension_file.dart';
import 'package:tmbi/config/app_navigator.dart';
import 'package:tmbi/config/notification/notification_service.dart';
import 'package:tmbi/config/palette.dart';
import 'package:tmbi/config/screen_config.dart';
import 'package:tmbi/config/sp_helper.dart';
import 'package:tmbi/db/dao/sync_dao.dart';
import 'package:tmbi/db/db_constant.dart';
import 'package:tmbi/network/api_service.dart';
import 'package:tmbi/repo/inquiry_repo.dart';
import 'package:tmbi/repo/login_repo.dart';
import 'package:tmbi/screens/login_screen.dart';
import 'package:tmbi/screens/new_task/new_task_dashboard_screen.dart';
import 'package:tmbi/screens/new_task/sync_screen.dart';
import 'package:tmbi/viewmodel/inquiry_create_viewmodel.dart';

import 'config/router.dart';
import 'firebase_options.dart';
import 'viewmodel/viewmodel.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Initialize local notifications early so reminder taps are handled even if
  // the user bypasses the login screen (auto-login path).
  await NotificationService().initLocalNotification(requestPermissions: false);

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
            //loginRepo: LoginRepo(dio: ApiService().provideDio()),
            inquiryRepo: InquiryRepo(
                dio: ApiService(
                        "https://ego.rflgroupbd.com:8077/ords/rpro/kickall/")
                    .provideDio(),
                fileDio: ApiService(
                        "https://ego.rflgroupbd.com:8077/ords/rpro/kickall/")
                    .fileUploadDio()),
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
      ],
      child: MaterialApp(
          title: 'Kick Track',
          debugShowCheckedModeBanner: false,
          onGenerateRoute: (settings) => generateRoute(settings),
          navigatorKey: AppNavigator.key,
          theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Palette.mainColor),
              useMaterial3: true,
              scaffoldBackgroundColor: Palette.scaffold),
          home: const SplashScreen()),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkLoginState();
  }

  Future<void> _checkLoginState() async {
    final userResponse = await SPHelper().getUser();
    final isSaved = await SPHelper().isCredentialSaved();

    if (!mounted) return;

    if (isSaved &&
        userResponse != null &&
        userResponse.users != null &&
        userResponse.users!.isNotEmpty) {
      final staffId = userResponse.users![0].staffId ?? "";
      final staffName = userResponse.users![0].staffName ?? "";

      if (staffId.isEmpty) {
        _goToLogin();
        return;
      }

      final isEmailUser = staffId.isEmail();

      if (!isEmailUser) {
        final syncDao = SyncDao();
        final isExist = await syncDao.isTableExist(DBConstant.tableStaff);
        final isEmpty = await syncDao.isTableEmpty(DBConstant.tableStaff);

        if (!mounted) return;

        if (isExist && !isEmpty) {
          Navigator.pushReplacementNamed(
            context,
            NewTaskDashboardScreen.routeName,
            arguments: {'staffId': staffId, 'name': staffName},
          );
        } else {
          Navigator.pushReplacementNamed(
            context,
            SyncScreen.routeName,
            arguments: staffId,
          );
        }
      } else {
        if (!mounted) return;
        Navigator.pushReplacementNamed(
          context,
          NewTaskDashboardScreen.routeName,
          arguments: {'staffId': staffId, 'name': staffName},
        );
      }
    } else {
      _goToLogin();
    }
  }

  void _goToLogin() {
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
