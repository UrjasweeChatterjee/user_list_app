import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../models/user.dart';

class UserData {
  late final Dio _dio;
  
  UserData() {
    _dio = Dio(
      BaseOptions(
        headers: {
          'Content-Type': 'application/json',
          'X-API-Key': 'reqres-free-v1', // API key
        },
        validateStatus: (status) {
          return status! < 500; // Accept all status codes less than 500
        },
        baseUrl: 'https://reqres.in/api', // Set base URL for all requests
      ),
    );
    
    // Add an interceptor to ensure the API key is set for all requests
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // Ensure API key is set for all requests
          options.headers['X-API-Key'] = 'reqres-free-v1';
          debugPrint('Making request to: ${options.uri}');
          return handler.next(options);
        },
        onResponse: (response, handler) {
          debugPrint('Received response with status: ${response.statusCode}');
          return handler.next(response);
        },
        onError: (DioException e, handler) {
          debugPrint('Error in request: ${e.message}');
          return handler.next(e);
        },
      ),
    );
  }

  Future<UserResponse> fetchUsers(int page, {int results = 6}) async {
    try {
      debugPrint('Fetching users: page=$page, results=$results');
      
      // Make a direct Dio call to debug the issue
      final directResponse = await _dio.get(
        '/users',
        queryParameters: {'page': page, 'per_page': results},
      );
      
      debugPrint('Direct API response: ${directResponse.statusCode}');
      debugPrint('Response data: ${directResponse.data}');
      
      if (directResponse.statusCode == 200) {
        // Manually parse the response to ensure it works
        final UserResponse userResponse = UserResponse.fromJson(directResponse.data);
        debugPrint('Users fetched successfully: ${userResponse.users.length} users');
        return userResponse;
      } else {
        throw Exception('Failed to load users: ${directResponse.statusCode}');
      }
    } on DioException catch (e) {
      debugPrint('DioException in fetchUsers: ${e.message}');
      debugPrint('DioException response: ${e.response?.data}');
      throw Exception('Failed to load users: ${e.message}');
    } catch (e) {
      debugPrint('Unexpected error in fetchUsers: $e');
      throw Exception('Failed to load users: $e');
    }
  }

  Future<User> fetchUserDetails(String userId) async {
    try {
      debugPrint('Fetching user details for userId: $userId');
      
      // Make a direct Dio call to debug the issue
      final directResponse = await _dio.get(
        '/users/$userId',
      );
      
      debugPrint('Direct API response: ${directResponse.statusCode}');
      debugPrint('Response data: ${directResponse.data}');
      
      if (directResponse.statusCode == 200) {
        // Manually parse the response to ensure it works
        final User user = User.fromJson(directResponse.data);
        debugPrint('User details fetched successfully: ${user.fullName}');
        return user;
      } else {
        throw Exception('Failed to load user details: ${directResponse.statusCode}');
      }
    } on DioException catch (e) {
      debugPrint('DioException in fetchUserDetails: ${e.message}');
      debugPrint('DioException response: ${e.response?.data}');
      throw Exception('Failed to load user details: ${e.message}');
    } catch (e) {
      debugPrint('Unexpected error in fetchUserDetails: $e');
      throw Exception('Failed to load user details: $e');
    }
  }

  // Update a user with PUT request
  Future<User> updateUser(String userId, User updatedUser) async {
    try {
      debugPrint('Updating user with ID: $userId');
      
      // Prepare the data to be sent in the format expected by the API
      final Map<String, dynamic> userData = {
        'first_name': updatedUser.firstName,
        'last_name': updatedUser.lastName,
        'email': updatedUser.email,
        // Add any other fields you want to update
      };
      
      // Make a direct Dio call to update the user
      final directResponse = await _dio.put(
        '/users/$userId',
        data: userData,
      );
      
      debugPrint('Update user response: ${directResponse.statusCode}');
      debugPrint('Response data: ${directResponse.data}');
      
      if (directResponse.statusCode == 200 || directResponse.statusCode == 201) {
        // ReqRes API might not return the full updated user data
        // If the API returns data, use it; otherwise, use our local data
        if (directResponse.data != null && directResponse.data.containsKey('updatedAt')) {
          // Create a user with the data we have
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
        throw Exception('Failed to update user: ${directResponse.statusCode}');
      }
    } on DioException catch (e) {
      debugPrint('DioException in updateUser: ${e.message}');
      debugPrint('DioException response: ${e.response?.data}');
      throw Exception('Failed to update user: ${e.message}');
    } catch (e) {
      debugPrint('Unexpected error in updateUser: $e');
      throw Exception('Failed to update user: $e');
    }
  }
  
  // Delete a user with DELETE request
  Future<bool> deleteUser(String userId) async {
    try {
      debugPrint('Deleting user with ID: $userId');
      
      // Make a direct Dio call to delete the user
      final directResponse = await _dio.delete(
        '/users/$userId',
      );
      
      debugPrint('Delete user response: ${directResponse.statusCode}');
      
      // ReqRes API typically returns 204 No Content for successful deletion
      // For mock APIs like reqres.in, we'll accept 200 and 204 as success
      if (directResponse.statusCode == 204 || directResponse.statusCode == 200) {
        return true;
      } else if (directResponse.statusCode == 404) {
        // If the user doesn't exist on the server, we'll still consider it a success
        // since the end result is that the user is not there
        return true;
      } else {
        throw Exception('Failed to delete user: ${directResponse.statusCode}');
      }
    } on DioException catch (e) {
      debugPrint('DioException in deleteUser: ${e.message}');
      debugPrint('DioException response: ${e.response?.statusCode}');
      
      // For reqres.in API, we'll treat certain errors as success
      // since it's a mock API and doesn't actually delete anything
      if (e.response?.statusCode == 204 || e.response?.statusCode == 200) {
        return true;
      }
      throw Exception('Failed to delete user: ${e.message}');
    } catch (e) {
      debugPrint('Unexpected error in deleteUser: $e');
      throw Exception('Failed to delete user: $e');
    }
  }
}
