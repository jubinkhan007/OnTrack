import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:tmbi/config/converts.dart';
import 'package:tmbi/config/extension_file.dart';
import 'package:tmbi/config/notification/notification_service.dart';
import 'package:tmbi/config/app_theme.dart';
import 'package:tmbi/config/palette.dart';
import 'package:tmbi/config/sp_helper.dart';
import 'package:tmbi/config/strings.dart';
import 'package:tmbi/db/dao/sync_dao.dart';
import 'package:tmbi/models/user_response.dart';
import 'package:tmbi/network/ui_state.dart';
import 'package:tmbi/screens/new_task/signup_screen.dart';
import 'package:tmbi/screens/new_task/sync_screen.dart';
import 'package:tmbi/screens/screens.dart';
import 'package:tmbi/viewmodel/new_task/signup_viewmodel.dart';
import 'package:tmbi/viewmodel/viewmodel.dart';
import 'package:tmbi/widgets/widgets.dart';
import 'package:url_launcher/url_launcher.dart';

import '../config/notification/notification_server_key.dart';
import '../db/dao/staff_dao.dart';
import '../db/db_constant.dart';

class LoginScreen extends StatelessWidget {
  static const String routeName = '/login_screen';

  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppGradients.header),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 22),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 520),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 18),
                    Text(
                      Strings.app_name,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: Converts.c24 + 4,
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.2,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      Strings.transforming_inquiries,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: Converts.c12 + 1,
                        color: Colors.white.withOpacity(0.85),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 22),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(14, 16, 14, 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              Strings.login_using_your_hris,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: Converts.c16,
                                color: AppColors.primary,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 12),
                            const LoginOperation(),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class LoginOperation extends StatefulWidget {
  const LoginOperation({super.key});

  @override
  State<LoginOperation> createState() => _LoginOperationState();
}

class _LoginOperationState extends State<LoginOperation> {
  final _loginFormKey = GlobalKey<FormState>();

  final TextEditingController _idTEController = TextEditingController();
  final TextEditingController _passwordTEController = TextEditingController();

  bool _rememberMe = false;
  String? _firebaseDeviceToken;

  // notification service
  NotificationService notificationService = NotificationService();

  @override
  void initState() {
    super.initState();
    _loadSavedCredential();

    // Ensure APNs is ready before getting FCM token
    /*WidgetsBinding.instance.addPostFrameCallback((_) async {
      await notificationService.requestNotificationPermission();
      await notificationService.initLocalNotification();
      notificationService.firebaseInit();
      notificationService.listenTokenRefresh();

      String? token = await notificationService.getDeviceToken();
      setState(() => _firebaseDeviceToken = token);

      debugPrint("Final Token: $_firebaseDeviceToken");
    });
    */
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await notificationService.requestNotificationPermission();
      await notificationService.initLocalNotification();
      notificationService.firebaseInit();
      notificationService.listenTokenRefresh();

      final token = await notificationService.getDeviceToken();

      setState(() {
        _firebaseDeviceToken = token;
      });

      debugPrint("FINAL TOKEN: $_firebaseDeviceToken");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LoginViewmodel>(builder: (context, loginViewModel, child) {
      return Form(
        key: _loginFormKey,
        child: Padding(
          padding: EdgeInsets.only(
            left: Converts.c24,
            right: Converts.c24,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// staff id
              TextFieldCustom(
                controller: _idTEController,
                hintText: Strings.staff_id,
                obscureText: false,
                textInputType: TextInputType.text,
                cpVertical: 0,
                cpHorizontal: 0,
                hintColor: AppColors.muted,
                iconColor: AppColors.muted,
                focusedColor: AppColors.accent,
                hintFontSize: Converts.c16,
                icon: Icons.email_outlined,
                iconSize: Converts.c24,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return Strings.required;
                  }
                  return null;
                },
              ),
              SizedBox(
                height: Converts.c16,
              ),

              /// password
              TextFieldCustom(
                controller: _passwordTEController,
                hintText: Strings.password,
                obscureText: true,
                textInputType: TextInputType.text,
                cpVertical: 0,
                cpHorizontal: 0,
                hintColor: AppColors.muted,
                iconColor: AppColors.muted,
                focusedColor: AppColors.accent,
                hintFontSize: Converts.c16,
                icon: Icons.lock_outline,
                iconSize: Converts.c24,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return Strings.required;
                  }
                  return null;
                },
              ),

              /*SizedBox(
                height: Converts.c16,
              ),*/

              /// remember me
              CheckBox(
                  title:
                      "${Strings.remember_me} (${_firebaseDeviceToken != null && _firebaseDeviceToken!.length >= 4 ? _firebaseDeviceToken!.substring(0, 4) : 'N'})",
                  isTitleBold: false,
                  isChecked: _rememberMe,
                  onChecked: (value) {
                    _rememberMe = value == "Y" ? true : false;
                  }),

              /// button
              ButtonCustom1(
                btnText: Strings.login,
                btnHeight: Converts.c48,
                bgColor: AppColors.accent,
                btnWidth: double.infinity,
                cornerRadius: 14,
                isLoading: loginViewModel.uiState == UiState.loading,
                stockColor: AppColors.accent,
                onTap: () async {
                  if (_loginFormKey.currentState!.validate()) {
                    // call api for validate user
                    await loginViewModel.userAuth(_idTEController.text,
                        _passwordTEController.text, _firebaseDeviceToken);

                    if (loginViewModel.uiState == UiState.error) {
                      _showMessage(loginViewModel.message.toString());
                    } else if (loginViewModel.uiState == UiState.success) {
                      if (loginViewModel.userResponse != null) {
                        if (loginViewModel.userResponse!.users != null) {
                          if (loginViewModel.userResponse!.users!.isNotEmpty) {
                            // saved password based of 'Remember me' flag
                            /*_saveCredential(_passwordTEController.text,
                                loginViewModel.userResponse!);*/
                            if (_rememberMe) {
                              loginViewModel.userResponse!.users![0].password =
                                  _passwordTEController.text;
                            } else {
                              loginViewModel.userResponse!.users![0].password =
                                  "";
                            }
                            await SPHelper().saveCredentialFlag(_rememberMe);
                            await SPHelper()
                                .saveUser(loginViewModel.userResponse!);
                            /*Navigator.pushNamed(context, HomeScreen.routeName,
                                arguments: loginViewModel
                                    .userResponse!.users![0].staffId);*/
                            bool isEmailUser = loginViewModel
                                .userResponse!.users![0].staffId!
                                .isEmail();

                            if (!isEmailUser) {
                              final syncDao = SyncDao();
                              bool isExist = await syncDao
                                  .isTableExist(DBConstant.tableStaff);
                              bool isEmpty = await syncDao
                                  .isTableEmpty(DBConstant.tableStaff);
                              if (context.mounted) {
                                Navigator.pushNamed(
                                  context,
                                  isExist && !isEmpty
                                      ? NewTaskDashboardScreen.routeName
                                      : SyncScreen.routeName,
                                  //arguments: loginViewModel.userResponse!.users![0].staffId
                                  arguments: {
                                    'staffId': loginViewModel
                                        .userResponse!.users![0].staffId,
                                    'name': loginViewModel
                                        .userResponse!.users![0].staffName,
                                  },
                                );
                              }
                            } else {
                              if (context.mounted) {
                                Navigator.pushNamed(
                                  context, NewTaskDashboardScreen.routeName,
                                  //arguments: loginViewModel.userResponse!.users![0].staffId
                                  arguments: {
                                    'staffId': loginViewModel
                                        .userResponse!.users![0].staffId,
                                    'name': loginViewModel
                                        .userResponse!.users![0].staffName,
                                  },
                                );
                              }
                            }
                          } else {
                            _showMessage(
                                loginViewModel.userResponse!.status!.message!,
                                isUpdate: loginViewModel
                                            .userResponse!.status!.code! ==
                                        501
                                    ? true
                                    : false);
                          }
                        } else {
                          _showMessage(Strings.login_validation_error);
                        }
                      }
                    } else {
                      _showMessage(Strings.something_went_wrong);
                    }
                  }
                },
              ),
              SizedBox(
                height: Converts.c20,
              ),
              // this is not for android
              Platform.isIOS
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                SignupScreen.routeName,
                              );
                            },
                            child: const Text(
                              "Don't have an account? Sign Up",
                              style: TextStyle(color: Colors.black),
                            )),
                      ],
                    )
                  : const SizedBox.shrink(),
            ],
          ),
        ),
      );
    });
  }

  _showMessage(String message, {bool isUpdate = false}) {
    context.hideKeyboard;
    final snackBar = SnackBar(
        content: TextViewCustom(
          text: message,
          tvColor: Colors.white,
          fontSize: Converts.c16,
          isBold: false,
          isRubik: true,
          isTextAlignCenter: false,
        ),
        action: SnackBarAction(
          label: isUpdate ? 'Update' : 'Ok',
          onPressed: () {
            if (isUpdate) {
              _launchAppStore();
            }
          },
        ),
        duration: Duration(seconds: isUpdate ? 1 * 60 : 5));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  _loadSavedCredential() async {
    bool isSaved = await SPHelper().isCredentialSaved();
    UserResponse? userResponse = await SPHelper().getUser();
    // generate server key
    /*NotificationServerKey serverKey = NotificationServerKey();
    String key = await serverKey.getServerKey();
    // test purpose
    Clipboard.setData(ClipboardData(text: key));
    debugPrint("SERVER_KEY::$key");*/
    // update user auth
    setState(() {
      _rememberMe = isSaved;
      if (_rememberMe) {
        if (userResponse != null) {
          String? staffId = userResponse.users![0].staffId;
          String? password = userResponse.users![0].password;
          _idTEController.text = staffId ?? "";
          _passwordTEController.text = password ?? "";
        }
      } else {
        _idTEController.text = "";
        _passwordTEController.text = "";
      }
    });
  }

  Future<void> _launchAppStore() async {
    String url;
    // Check the platform (Android or iOS)
    if (Theme.of(context).platform == TargetPlatform.iOS) {
      url = "";
    } else if (Theme.of(context).platform == TargetPlatform.android) {
      url =
          "https://play.google.com/store/apps/details?id=com.prangroup.mis93.tmbi&pli=1";
    } else {
      throw 'This platform is not supported for opening the app store.';
    }
    // Try to launch the URL
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }
}
