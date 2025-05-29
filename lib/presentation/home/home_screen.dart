import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/auth_controller.dart';
import '../../controllers/user_controller.dart';
import 'home_body.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();

    // Use a post-frame callback to ensure the widget is fully built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      debugPrint('HomeScreen: Fetching users after build');
      final userController = Provider.of<UserController>(context, listen: false);
      
      // Force a refresh to ensure we get the latest data
      userController.fetchUsers(refresh: true).then((_) {
        debugPrint('HomeScreen: User fetch completed');
      }).catchError((error) {
        debugPrint('HomeScreen: Error fetching users: $error');
        // Show a snackbar with the error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load users: $error')),
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Users'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              // Logout the user
              final authController = Provider.of<AuthController>(context, listen: false);
              authController.logout();
              // Navigate to login screen
              Navigator.pushReplacementNamed(context, '/login');
            },
            tooltip: 'Logout',
          ),
        ],
      ),
      body: Consumer<UserController>(
        builder: (context, controller, child) {
          return HomeBody(controller: controller);
        },
      ),
    );
  }
}
