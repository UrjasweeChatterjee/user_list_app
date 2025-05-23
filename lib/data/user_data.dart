import 'package:dio/dio.dart';

import '../models/user.dart';

class UserData {
  final Dio _dio = Dio();
  final String _baseUrl = 'https://reqres.in/api';

  Future<UserResponse> fetchUsers(int page, {int results = 6}) async {
    try {
      final response = await _dio.get(
        '$_baseUrl/users',
        queryParameters: {
          'page': page,
          'per_page': results,
        },
      );
      return UserResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception('Failed to load users: ${e.message}');
    }
  }

  Future<User> fetchUserDetails(String userId) async {
    try {
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
