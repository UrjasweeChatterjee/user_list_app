import 'package:flutter/material.dart';

import '../data/user_data.dart';
import '../models/user.dart';

class UserController with ChangeNotifier {
  final UserData _userData = UserData();
  List<User> _users = [];
  bool _isLoading = false;
  String? _error;
  int _currentPage = 1;
  int _totalPages = 1;

  List<User> get users => _users;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasMorePages => _currentPage < _totalPages;

  Future<void> fetchUsers({bool refresh = false}) async {
    _isLoading = true;
    _error = null;

    if (refresh) {
      _users = [];
      _currentPage = 1;
    }

    notifyListeners();

    try {
      final response = await _userData.fetchUsers(
        _currentPage,
        results: 6, // ReqRes API default is 6 users per page
      );

      if (refresh) {
        _users = response.users;
      } else {
        _users.addAll(response.users);
      }

      _totalPages = response.totalPages;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadNextPage() async {
    if (_isLoading || _currentPage >= _totalPages) return;

    _currentPage++;
    await fetchUsers(refresh: false);
  }

  Future<User> getUserDetails(String userId) async {
    // First check if the user is already in our list
    final cachedUser = _users.firstWhere(
      (user) => user.id == userId,
      orElse:
          () =>
              User(id: '', email: '', firstName: '', lastName: '', avatar: ''),
    );

    // If we found the user in our cache, return it
    if (cachedUser.id.isNotEmpty) {
      return cachedUser;
    }

    // Otherwise fetch from API
    try {
      return await _userData.fetchUserDetails(userId);
    } catch (e) {
      throw Exception('Failed to get user details');
    }
  }
}
