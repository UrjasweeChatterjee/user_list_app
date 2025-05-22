import 'package:dio/dio.dart';

import '../models/user.dart';

class UserData {
  final Dio _dio = Dio();
  final String _baseUrl = 'https://randomuser.me/api';

  Future<UserResponse> fetchUsers(int page, {int results = 10}) async {
    try {
      final response = await _dio.get(
        _baseUrl,
        queryParameters: {
          'results': results,
          'page': page,
        },
      );
      return UserResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception('Failed to load users: ${e.message}');
    }
  }

  Future<User> fetchUserDetails(String userId) async {
    try {
      // RandomUser API doesn't have a specific endpoint for individual users
      // So we'll use the seed parameter to always get the same user for a given ID
      final response = await _dio.get(
        _baseUrl,
        queryParameters: {
          'seed': userId,
          'results': 1,
        },
      );
      
      if (response.data['results'] != null && 
          response.data['results'].isNotEmpty) {
        return User.fromJson(response.data['results'][0]);
      } else {
        throw Exception('User not found');
      }
    } on DioException catch (e) {
      throw Exception('Failed to load user details: ${e.message}');
    }
  }
}
