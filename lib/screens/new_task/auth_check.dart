import 'package:flutter/material.dart';
import 'package:tmbi/models/user_response.dart';
import 'package:tmbi/screens/login_screen.dart';
import 'package:tmbi/screens/new_task/new_task_dashboard_screen.dart';
import '../../config/sp_helper.dart';

class AuthCheck extends StatelessWidget {
  AuthCheck({super.key});

  // Function to check if user is logged in
  Future<UserResponse?> _getUserFromSP() async {
    // Fetch user data from SharedPreferences
    return await SPHelper().getUser();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserResponse?>(
      future: _getUserFromSP(), // Get user from SharedPreferences
      builder: (context, snapshot) {
        // Show loading while the data is being fetched
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        // Handle errors (in case of an error while fetching)
        if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(title: const Text('Error')),
            body: const Center(child: Text('An error occurred!')),
          );
        }

        // If no user is found in SharedPreferences, navigate to login page
        if (snapshot.data == null) {
          Future.microtask(() {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => LoginScreen()),
            );
          });
          return Scaffold(
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        // If user is found, navigate to the home/dashboard page
        UserResponse user = snapshot.data!;
        Future.microtask(() {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => NewTaskDashboardScreen(
                staffId: user.users![0].staffId!,
              ),
            ),
          );
        });

        // We can return any widget while waiting for navigation (though it's unnecessary here)
        return Scaffold(
          body: const Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}
