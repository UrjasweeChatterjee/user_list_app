import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/auth_controller.dart';

class AuthCheck extends StatelessWidget {
  const AuthCheck({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthController>(
      builder: (context, authController, _) {
        // Show loading indicator while checking authentication status
        if (!authController.isInitialized || authController.isLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // If user is already authenticated, go to home screen
        if (authController.isAuthenticated) {
          // Use a post-frame callback to avoid build errors
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pushReplacementNamed(context, '/home');
          });
          // Show loading while navigating
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        } else {
          // If not authenticated, go to login screen
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pushReplacementNamed(context, '/login');
          });
          // Show loading while navigating
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
      },
    );
  }
}
