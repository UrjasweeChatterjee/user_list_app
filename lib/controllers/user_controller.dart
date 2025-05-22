import 'package:flutter/material.dart';

import '../data/user_data.dart';
import '../models/user.dart';

class UserController with ChangeNotifier {
  final UserData _userData = UserData();
  List<User> _users = [];
  bool _isLoading = false;
  String? _error;

  List<User> get users => _users;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchUsers({bool refresh = false}) async {
    _isLoading = true;
    _error = null;
    if (refresh) _users = [];
    notifyListeners();

    try {
      final response = await _userData.fetchUsers(
        1,
        results: 10, // Get 10 users per page
      );
      _users = response.users;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<User> getUserDetails(String userId) async {
    try {
      return await _userData.fetchUserDetails(userId);
    } catch (e) {
      throw Exception('Failed to get user details');
    }
  }
}
