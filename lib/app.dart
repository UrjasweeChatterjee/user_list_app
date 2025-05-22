import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'controllers/user_controller.dart';
import 'presentation/home/home_screen.dart';
import 'presentation/home/user_details/user_details_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => UserController(),
      child: MaterialApp(
        title: 'User List App',
        theme: ThemeData(primarySwatch: Colors.blue),
        initialRoute: '/',
        routes: {
          '/': (context) => const HomeScreen(),
          '/user_details': (context) => const UserDetailsScreen(),
        },
      ),
    );
  }
}
