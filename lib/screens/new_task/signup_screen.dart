import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tmbi/viewmodel/new_task/signup_viewmodel.dart';
import 'package:tmbi/widgets/new_task/custom_edit_text.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});
  static const String routeName = '/signup_screen';

  static Widget create() {
    return ChangeNotifierProvider(
      create: (_) => SignupViewmodel(),
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
          padding: const EdgeInsets.all(24),
          child: Container(
            padding: const EdgeInsets.all(24),
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
                    color: Colors.blue.shade50,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.check_circle_outline,
                      size: 40, color: Colors.blue.shade600),
                ),

                const SizedBox(height: 16),

                const Text(
                  "Create Your Account",
                  style:
                  TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 6),

                const Text(
                  "Start organizing your life, one task at a time.",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black54),
                ),

                const SizedBox(height: 30),

                /// FULL NAME
                CustomEditText(
                  label: "Full Name",
                  hint: "Enter your full name",
                  icon: Icons.person,
                  onChanged: provider.setFullName,
                ),
                const SizedBox(height: 20),

                /// EMAIL
                CustomEditText(
                  label: "Email",
                  hint: "Enter your email",
                  icon: Icons.email,
                  onChanged: provider.setEmail,
                ),
                const SizedBox(height: 20),

                /// PASSWORD
                CustomEditText(
                  label: "Password",
                  hint: "Enter your password",
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
                const SizedBox(height: 20),

                /// CONFIRM PASSWORD
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

                const SizedBox(height: 30),

                /// BUTTON
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: provider.validate()
                        ? () {
                      // TODO: Connect to Firebase/Auth API
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text("Account created!")));
                    }
                        : null,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text("Create Account"),
                  ),
                ),

                const SizedBox(height: 20),

                GestureDetector(
                  onTap: () {
                    // TODO: Navigate to login
                  },
                  child: const Text(
                    "Already have an account? Log In",
                    style: TextStyle(
                        color: Colors.blue, fontWeight: FontWeight.w500),
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
