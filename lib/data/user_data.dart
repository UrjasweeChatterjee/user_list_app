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
}
