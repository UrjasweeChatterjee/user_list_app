import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController with ChangeNotifier {
  // List of allowed user emails that can access the app
  final List<String> _allowedUsers = [
    'eve.holt@reqres.in',
    'tracey.ramos@reqres.in',
    'charles.morris@reqres.in',
    'emma.wong@reqres.in',
    'janet.weaver@reqres.in',
    'george.bluth@reqres.in'
  ];
  final Dio _dio = Dio(
    BaseOptions(
      headers: {
        'Content-Type': 'application/json',
        'X-API-Key': 'reqres-free-v1', // Add the API key
      },
      validateStatus: (status) {
        return status! < 500; // Accept all status codes less than 500
      },
    ),
  );
  final String _baseUrl = 'https://reqres.in/api'; // Using reqres.in for demo

  bool _isLoading = false;
  String? _token;
  String? _error;
  bool _initialized = false;

  bool get isLoading => _isLoading;
  bool get isAuthenticated => _token != null;
  bool get isInitialized => _initialized;
  String? get error => _error;
  String? get token => _token;

  AuthController() {
    _loadToken();
  }

  Future<void> _loadToken() async {
    _isLoading = true;
    notifyListeners();
    
    try {
      final prefs = await SharedPreferences.getInstance();
      _token = prefs.getString('auth_token');
    } catch (e) {
      debugPrint('Error loading token: ${e.toString()}');
      _token = null;
    } finally {
      _isLoading = false;
      _initialized = true;
      notifyListeners();
    }
  }

  Future<void> _saveToken(String token) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', token);
      _token = token;
      debugPrint('Token saved successfully: $token');
    } catch (e) {
      debugPrint('Error saving token: ${e.toString()}');
    }
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    // Check if the email is in the allowed users list
    if (!_allowedUsers.contains(email.trim().toLowerCase())) {
      _error = 'Access denied: This email is not authorized to use this app';
      _isLoading = false;
      notifyListeners();
      return false;
    }

    try {
      // Ensure the API key is set for this request
      _dio.options.headers['X-API-Key'] = 'reqres-free-v1';

      final response = await _dio.post(
        '$_baseUrl/login',
        data: {'email': email, 'password': password},
      );

      debugPrint('Login response: ${response.statusCode}, data: ${response.data}');

      if (response.statusCode == 200 && response.data['token'] != null) {
        await _saveToken(response.data['token']);
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _error = response.data['error'] ?? 'Invalid credentials';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } on DioException catch (e) {
      debugPrint('Login error: ${e.toString()}');
      _error = e.response?.data?['error'] ?? 'Login failed';
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      debugPrint('Unexpected error: ${e.toString()}');
      _error = 'An unexpected error occurred';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> register(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    // Check if the email is in the allowed users list for registration
    if (!_allowedUsers.contains(email.trim().toLowerCase())) {
      _error = 'Registration denied: This email is not authorized to register';
      _isLoading = false;
      notifyListeners();
      return false;
    }

    try {
      final response = await _dio.post(
        '$_baseUrl/register',
        data: {'email': email, 'password': password},
      );

      debugPrint('Register response: ${response.statusCode}, data: ${response.data}');

      if (response.statusCode == 200 && response.data['token'] != null) {
        await _saveToken(response.data['token']);
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _error = response.data['error'] ?? 'Registration failed';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } on DioException catch (e) {
      debugPrint('Registration error: ${e.toString()}');
      _error = e.response?.data?['error'] ?? 'Registration failed';
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      debugPrint('Unexpected error: ${e.toString()}');
      _error = 'An unexpected error occurred';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();
    
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('auth_token');
      _token = null;
    } catch (e) {
      debugPrint('Error during logout: ${e.toString()}');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
