import 'package:dio/dio.dart';

class ApiService {
  final Dio _dio = Dio();
  final String _apiKey =
      'your_api_key_here'; // Replace with your actual API key
  final String _baseUrl =
      'https://api.example.com'; // Replace with your API base URL

  Future<Response> getUsers() async {
    try {
      return await _dio.get(
        '$_baseUrl/users',
        options: Options(
          headers: {
            'Authorization': 'Bearer $_apiKey',
            'Content-Type': 'application/json',
          },
        ),
      );
    } on DioException catch (e) {
      throw Exception('Failed to load users: ${e.message}');
    }
  }

  Future<Response> getUserDetails(int userId) async {
    try {
      return await _dio.get(
        '$_baseUrl/users/$userId',
        options: Options(
          headers: {
            'Authorization': 'Bearer $_apiKey',
            'Content-Type': 'application/json',
          },
        ),
      );
    } on DioException catch (e) {
      throw Exception('Failed to load user details: ${e.message}');
    }
  }
}
