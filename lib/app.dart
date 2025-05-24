import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'controllers/auth_controller.dart';
import 'controllers/user_controller.dart';
import 'presentation/auth/login_screen.dart';
import 'presentation/auth/signup_screen.dart';
import 'presentation/home/home_screen.dart';
import 'presentation/home/user_details/user_details_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthController()),
        ChangeNotifierProvider(create: (context) => UserController()),
      ],
      child: MaterialApp(
        title: 'User List App',
        theme: ThemeData(primarySwatch: Colors.blue),
        // Start directly with login screen instead of auth check
        initialRoute: '/login',
        routes: {
          '/': (context) => const LoginScreen(), // Changed default route to login
          '/login': (context) => const LoginScreen(),
          '/signup': (context) => const SignupScreen(),
          '/home': (context) => const HomeScreen(),
          '/user_details': (context) => const UserDetailsScreen(),
        },
      ),
    );
  }
}
