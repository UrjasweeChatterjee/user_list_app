import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

class AuthController with ChangeNotifier {
  final Dio _dio = Dio();
  final String _baseUrl = 'https://reqres.in/api'; // Using reqres.in for demo
  
  bool _isLoading = false;
  String? _token;
  String? _error;

  bool get isLoading => _isLoading;
  bool get isAuthenticated => _token != null;
  String? get error => _error;
  String? get token => _token;

  AuthController() {
    _loadToken();
  }

  Future<void> _loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('auth_token');
    notifyListeners();
  }

  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
    _token = token;
  }

  Future<void> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _dio.post(
        '$_baseUrl/login',
        data: {
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 200 && response.data['token'] != null) {
        await _saveToken(response.data['token']);
      } else {
        _error = 'Invalid credentials';
      }
    } on DioException catch (e) {
      _error = e.response?.data?['error'] ?? 'Login failed';
    } catch (e) {
      _error = 'An unexpected error occurred';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> register(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _dio.post(
        '$_baseUrl/register',
        data: {
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 200 && response.data['token'] != null) {
        await _saveToken(response.data['token']);
      } else {
        _error = 'Registration failed';
      }
    } on DioException catch (e) {
      _error = e.response?.data?['error'] ?? 'Registration failed';
    } catch (e) {
      _error = 'An unexpected error occurred';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    _token = null;
    notifyListeners();
  }
}
