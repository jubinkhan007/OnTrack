import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tmbi/config/converts.dart';
import 'package:tmbi/config/palette.dart';
import 'package:tmbi/config/sp_helper.dart';
import 'package:tmbi/config/strings.dart';
import 'package:tmbi/network/ui_state.dart';
import 'package:tmbi/screens/screens.dart';
import 'package:tmbi/viewmodel/viewmodel.dart';
import 'package:tmbi/widgets/widgets.dart';

class LoginScreen extends StatelessWidget {
  static const String routeName = '/login_screen';

  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start, // Center vertically
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: Converts.c48,
                ),
                TextViewCustom(
                    text: Strings.app_name,
                    fontSize: Converts.c24,
                    tvColor: Palette.mainColor,
                    isTextAlignCenter: true,
                    isBold: true),
                TextViewCustom(
                    text: Strings.transforming_inquiries,
                    fontSize: Converts.c12,
                    tvColor: Palette.semiTv,
                    isBold: true),
                SizedBox(
                  height: Converts.c56,
                ),
                TextViewCustom(
                    text: Strings.login_using_your_hris,
                    fontSize: Converts.c16,
                    tvColor: Palette.normalTv,
                    isBold: false),
                SizedBox(
                  height: Converts.c32,
                ),
                const LoginOperation(),
              ],
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
            children: [
              TextFieldCustom(
                controller: _idTEController,
                hintText: Strings.staff_id,
                obscureText: false,
                textInputType: TextInputType.text,
                cpVertical: 0,
                cpHorizontal: 0,
                hintColor: Palette.semiTv,
                iconColor: Colors.white,
                focusedColor: Palette.mainColor,
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
              TextFieldCustom(
                controller: _passwordTEController,
                hintText: Strings.password,
                obscureText: true,
                textInputType: TextInputType.text,
                cpVertical: 0,
                cpHorizontal: 0,
                hintColor: Palette.semiTv,
                iconColor: Colors.white,
                focusedColor: Palette.mainColor,
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
              SizedBox(
                height: Converts.c32,
              ),
              ButtonCustom1(
                btnText: Strings.login,
                btnHeight: Converts.c48,
                bgColor: Palette.mainColor,
                btnWidth: double.infinity,
                cornerRadius: 4,
                isLoading: loginViewModel.uiState == UiState.loading,
                stockColor: Palette.mainColor,
                onTap: () async {
                  if (_loginFormKey.currentState!.validate()) {
                    await loginViewModel.userAuth(
                        _idTEController.text, _passwordTEController.text);
                    if (loginViewModel.uiState == UiState.error) {
                      _showMessage(loginViewModel.message.toString());
                    }
                    else if (loginViewModel.uiState == UiState.success) {
                      if (loginViewModel.userResponse != null) {
                        if (loginViewModel.userResponse!.users != null) {
                          if (loginViewModel.userResponse!.users!.isNotEmpty) {
                            await SPHelper().saveUser(loginViewModel.userResponse!);
                            Navigator.pushNamed(
                              context,
                              HomeScreen.routeName,
                            );
                          } else {
                            _showMessage(
                                loginViewModel.userResponse!.status!.message!);
                          }
                        } else {
                          _showMessage(Strings.login_validation_error);
                        }
                      }
                    }
                    else {
                      _showMessage(Strings.something_went_wrong);
                    }
                  }
                },
              ),
              SizedBox(
                height: Converts.c32,
              ),
            ],
          ),
        ),
      );
    });
  }

  _showMessage(String message) {
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
        label: 'Ok',
        onPressed: () {},
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

}
