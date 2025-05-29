import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  final String id;
  final String email;
  
  @JsonKey(name: 'first_name')
  final String firstName;
  
  @JsonKey(name: 'last_name')
  final String lastName;
  
  final String avatar;
  final String? phone;
  final String? cell;
  final String? nationality;
  final String? gender;
  final String? address;
  final int? age;

  User({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.avatar,
    this.phone,
    this.cell,
    this.nationality,
    this.gender,
    this.address,
    this.age,
  });

  String get fullName => '$firstName $lastName';
  
  // Generated fromJson method
  factory User.fromJson(Map<String, dynamic> json) {
    // Handle ReqRes API structure where data might be nested
    final userData = json.containsKey('data') ? json['data'] : json;
    
    // Handle case where id might be an int in the API response
    if (userData['id'] != null && userData['id'] is int) {
      userData['id'] = userData['id'].toString();
    }
    
    return _$UserFromJson(userData);
  }
  
  // Generated toJson method
  Map<String, dynamic> toJson() => _$UserToJson(this);
}

@JsonSerializable()
class UserResponse {
  @JsonKey(name: 'data')
  final List<User> users;
  
  final int page;
  
  @JsonKey(name: 'per_page')
  final int perPage;
  
  final int total;
  
  @JsonKey(name: 'total_pages')
  final int totalPages;

  UserResponse({
    required this.users,
    required this.page,
    required this.perPage,
    required this.total,
    required this.totalPages,
  });

  // Generated fromJson method
  factory UserResponse.fromJson(Map<String, dynamic> json) {
    // Ensure the json object has the expected structure
    if (!json.containsKey('data') || !json.containsKey('page')) {
      // If the response doesn't match expected format, create a default response
      return UserResponse(
        users: [],
        page: 1,
        perPage: 0,
        total: 0,
        totalPages: 0,
      );
    }
    return _$UserResponseFromJson(json);
  }
  
  // Generated toJson method
  Map<String, dynamic> toJson() => _$UserResponseToJson(this);
}
