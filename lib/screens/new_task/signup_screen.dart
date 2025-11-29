import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tmbi/network/ui_state.dart';
import 'package:tmbi/repo/new_task/sign_up_repo.dart';
import 'package:tmbi/viewmodel/new_task/signup_viewmodel.dart';
import 'package:tmbi/widgets/new_task/custom_edit_text.dart';

import '../../config/converts.dart';
import '../../network/api_service.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  static const String routeName = '/signup_screen';

  static Widget create() {
    return ChangeNotifierProvider(
      create: (_) => SignupViewmodel(
        signUpRepo: SignUpRepo(
            dio:
                ApiService("https://ego.rflgroupbd.com:8077/ords/rpro/kickall/")
                    .provideDio()),
      ),
      child: const SignupScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SignupViewmodel>(context);

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              children: [
                // Logo check mark
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.check_circle_outline,
                      size: Converts.c40, color: Colors.red.shade600),
                ),

                const SizedBox(height: 16),
                Text(
                  "Create Your Account",
                  style: TextStyle(
                      fontSize: Converts.c16, fontWeight: FontWeight.bold),
                ),

                //const SizedBox(height: 4),

                Text(
                  "Start organizing your life, one task at a time.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.black54, fontSize: Converts.c16 - 2),
                ),

                const SizedBox(height: 16),

                // Name
                CustomEditText(
                  label: "Full Name",
                  hint: "Enter your full name",
                  icon: Icons.person,
                  onChanged: provider.setFullName,
                ),
                const SizedBox(height: 16),

                // Email
                CustomEditText(
                  label: "Email",
                  hint: "Enter your email",
                  icon: Icons.email,
                  onChanged: provider.setEmail,
                ),
                const SizedBox(height: 16),

                // Password
                CustomEditText(
                  label: "Password",
                  hint: "Password (At least six digit)",
                  icon: Icons.lock,
                  obscure: provider.hidePassword,
                  onChanged: provider.setPassword,
                  suffix: IconButton(
                    icon: Icon(provider.hidePassword
                        ? Icons.visibility_off
                        : Icons.visibility),
                    onPressed: provider.togglePassword,
                  ),
                ),
                const SizedBox(height: 16),

                // Confirm Password
                CustomEditText(
                  label: "Confirm Password",
                  hint: "Confirm your password",
                  icon: Icons.lock,
                  obscure: provider.hideConfirmPassword,
                  onChanged: provider.setConfirmPassword,
                  suffix: IconButton(
                    icon: Icon(provider.hideConfirmPassword
                        ? Icons.visibility_off
                        : Icons.visibility),
                    onPressed: provider.toggleConfirmPassword,
                  ),
                ),

                const SizedBox(height: 20),

                // Button
                provider.uiState != UiState.loading
                    ? SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: provider.validate()
                              ? () async {
                                  await provider.signUp();

                                  if (provider.uiState == UiState.success) {
                                    if (context.mounted) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                              "Account created successfully!"),
                                          duration: Duration(seconds: 2),
                                        ),
                                      );
                                      Navigator.pop(context);
                                    }
                                  } else {
                                    if (context.mounted) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(provider.message!),
                                          duration: const Duration(seconds: 5),
                                        ),
                                      );
                                    }
                                  }
                                }
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            "Create Account",
                            style: TextStyle(color: Colors.black),
                          ),
                        ))
                    : SizedBox(
                        width: Converts.c20,
                        height: Converts.c20,
                        child: const CircularProgressIndicator(),
                      ),

                const SizedBox(height: 16),

                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    "Already have an account? Log In",
                    style: TextStyle(
                      color: Colors.black, /*fontWeight: FontWeight.w500*/
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
