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
  
  // Sets to keep track of updated and deleted users
  final Set<String> _deletedUserIds = {};
  final Map<String, User> _updatedUsers = {};

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

      // Filter out deleted users and apply updates to fetched users
      final List<User> filteredUsers = response.users.where((user) {
        // Skip users that have been deleted
        return !_deletedUserIds.contains(user.id);
      }).map((user) {
        // Apply any updates to users
        return _updatedUsers.containsKey(user.id) ? _updatedUsers[user.id]! : user;
      }).toList();

      if (refresh) {
        _users = filteredUsers;
      } else {
        _users.addAll(filteredUsers);
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
  
  // Update user information
  Future<User> updateUser(String userId, User updatedUser) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      // Call the API to update the user
      final updatedUserData = await _userData.updateUser(userId, updatedUser);
      
      // Store the updated user in our map
      _updatedUsers[userId] = updatedUserData;
      
      // Update the user in our local list
      final userIndex = _users.indexWhere((user) => user.id == userId);
      if (userIndex != -1) {
        _users[userIndex] = updatedUserData;
      }
      
      _isLoading = false;
      notifyListeners();
      return updatedUserData;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      throw Exception('Failed to update user: $_error');
    }
  }
  
  // Delete a user
  Future<bool> deleteUser(String userId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      // Call the API to delete the user
      final success = await _userData.deleteUser(userId);
      
      if (success) {
        // Add the user ID to our deleted set
        _deletedUserIds.add(userId);
        
        // Remove from updated users if it exists there
        _updatedUsers.remove(userId);
        
        // Remove the user from our local list
        _users.removeWhere((user) => user.id == userId);
      }
      
      _isLoading = false;
      notifyListeners();
      return success;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      throw Exception('Failed to delete user: $_error');
    }
  }
}
