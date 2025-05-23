class User {
  final String id;
  final String email;
  final String firstName;
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

  factory User.fromJson(Map<String, dynamic> json) {
    // ReqRes API structure is different
    // The data comes in a structure like: {"data": {user fields}}
    final userData = json['data'] ?? json;
    
    return User(
      id: userData['id']?.toString() ?? '',
      email: userData['email'] ?? '',
      firstName: userData['first_name'] ?? '',
      lastName: userData['last_name'] ?? '',
      avatar: userData['avatar'] ?? 'https://via.placeholder.com/150',
      // Extract these fields from the API response if they exist
      phone: userData['phone'] ?? userData['phone_number'],
      gender: userData['gender'],
      // These fields aren't provided by ReqRes API but we'll keep them for compatibility
      cell: userData['cell'],
      nationality: userData['nationality'],
      address: userData['address'],
      age: userData['age'] != null ? int.tryParse(userData['age'].toString()) : null,
    );
  }

  String get fullName => '$firstName $lastName';
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'avatar': avatar,
      'phone': phone,
      'cell': cell,
      'nationality': nationality,
      'gender': gender,
      'address': address,
      'age': age,
    };
  }
}

class UserResponse {
  final List<User> users;
  final int page;
  final int perPage;
  final int total;
  final int totalPages;

  UserResponse({
    required this.users,
    required this.page,
    required this.perPage,
    required this.total,
    required this.totalPages,
  });

  factory UserResponse.fromJson(Map<String, dynamic> json) {
    // ReqRes API structure
    var userList = json['data'] as List? ?? [];
    List<User> users = userList.map((user) => User.fromJson({'data': user})).toList();

    return UserResponse(
      users: users,
      page: json['page'] ?? 1,
      perPage: json['per_page'] ?? 0,
      total: json['total'] ?? 0,
      totalPages: json['total_pages'] ?? 0,
    );
  }
}
