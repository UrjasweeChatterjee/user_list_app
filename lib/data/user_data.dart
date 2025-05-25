import 'package:dio/dio.dart';

import '../models/user.dart';

class UserData {
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
  final String _baseUrl = 'https://reqres.in/api';

  Future<UserResponse> fetchUsers(int page, {int results = 6}) async {
    try {
      // Ensure the API key is set for this request
      _dio.options.headers['X-API-Key'] = 'reqres-free-v1';
      
      final response = await _dio.get(
        '$_baseUrl/users',
        queryParameters: {'page': page, 'per_page': results},
      );
      return UserResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception('Failed to load users: ${e.message}');
    }
  }

  Future<User> fetchUserDetails(String userId) async {
    try {
      // Ensure the API key is set for this request
      _dio.options.headers['X-API-Key'] = 'reqres-free-v1';
      
      // ReqRes API has a specific endpoint for individual users
      final response = await _dio.get('$_baseUrl/users/$userId');

      if (response.data != null) {
        return User.fromJson(response.data);
      } else {
        throw Exception('User not found');
      }
    } on DioException catch (e) {
      throw Exception('Failed to load user details: ${e.message}');
    }
  }

  // Update a user with PUT request
  Future<User> updateUser(String userId, User updatedUser) async {
    try {
      // Ensure the API key is set for this request
      _dio.options.headers['X-API-Key'] = 'reqres-free-v1';
      
      // Prepare the data to be sent in the format expected by the API
      final Map<String, dynamic> userData = {
        'first_name': updatedUser.firstName,
        'last_name': updatedUser.lastName,
        'email': updatedUser.email,
        // Add any other fields you want to update
      };
      
      // Make the PUT request to the exact endpoint
      final response = await _dio.put(
        '$_baseUrl/users/$userId',
        data: userData,
      );
      
      // For reqres.in API, a successful update returns status code 200
      if (response.statusCode == 200 || response.statusCode == 201) {
        // If the API doesn't return the updated user data, we'll use our local data
        if (response.data != null && response.data.containsKey('updatedAt')) {
          // The API returned some data, merge it with our local data
          return User(
            id: userId,
            firstName: updatedUser.firstName,
            lastName: updatedUser.lastName,
            email: updatedUser.email,
            avatar: updatedUser.avatar,
          );
        } else {
          // Just return our local data
          return updatedUser;
        }
      } else {
        throw Exception('Failed to update user: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Failed to update user: ${e.message}');
    }
  }
  
  // Delete a user with DELETE request
  Future<bool> deleteUser(String userId) async {
    try {
      // Ensure the API key is set for this request
      _dio.options.headers['X-API-Key'] = 'reqres-free-v1';
      
      // Make the DELETE request to the exact endpoint
      final response = await _dio.delete('$_baseUrl/users/$userId');
      
      // ReqRes API typically returns 204 No Content for successful deletion
      // For mock APIs like reqres.in, we'll accept 200 and 204 as success
      if (response.statusCode == 204 || response.statusCode == 200) {
        return true;
      } else if (response.statusCode == 404) {
        // If the user doesn't exist on the server, we'll still consider it a success
        // since the end result is that the user is not there
        return true;
      } else {
        throw Exception('Failed to delete user: ${response.statusCode}');
      }
    } on DioException catch (e) {
      // For reqres.in API, we'll treat certain errors as success
      // since it's a mock API and doesn't actually delete anything
      if (e.response?.statusCode == 204 || e.response?.statusCode == 200) {
        return true;
      }
      throw Exception('Failed to delete user: ${e.message}');
    }
  }
}
