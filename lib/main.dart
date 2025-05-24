import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';

void main() async {
  // Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Clear any existing token on app start to force login
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('auth_token');

  runApp(const MyApp());
}
