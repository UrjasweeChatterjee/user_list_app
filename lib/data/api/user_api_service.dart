import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../../models/user.dart';

part 'user_api_service.g.dart';

@RestApi(baseUrl: "https://reqres.in/api")
abstract class UserApiService {
  factory UserApiService(Dio dio, {String baseUrl}) = _UserApiService;

  @GET("/users")
  Future<UserResponse> getUsers(
    @Query("page") int page,
    @Query("per_page") int perPage,
  );

  @GET("/users/{id}")
  Future<User> getUserDetails(@Path("id") String userId);

  @PUT("/users/{id}")
  Future<User> updateUser(
    @Path("id") String userId,
    @Body() Map<String, dynamic> userData,
  );

  @DELETE("/users/{id}")
  Future<HttpResponse<dynamic>> deleteUser(@Path("id") String userId);
}
