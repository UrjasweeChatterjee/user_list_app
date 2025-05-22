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
    // Extract location data if available
    String? formattedAddress;
    if (json['location'] != null) {
      final location = json['location'];
      final street = location['street'];
      formattedAddress = '${street['number']} ${street['name']}, ${location['city']}, ${location['country']}';
    }

    // Extract picture URL from the picture object
    String avatar = 'https://randomuser.me/api/portraits/lego/1.jpg';
    if (json['picture'] != null && json['picture']['large'] != null) {
      avatar = json['picture']['large'];
    }

    return User(
      id: json['login']?['uuid'] ?? '',
      email: json['email'] ?? '',
      firstName: json['name']?['first'] ?? '',
      lastName: json['name']?['last'] ?? '',
      avatar: avatar,
      phone: json['phone'],
      cell: json['cell'],
      nationality: json['nat'],
      gender: json['gender'],
      address: formattedAddress,
      age: json['dob']?['age'],
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
  final String seed;
  final int results;
  final String version;

  UserResponse({
    required this.users,
    required this.page,
    required this.seed,
    required this.results,
    required this.version,
  });

  factory UserResponse.fromJson(Map<String, dynamic> json) {
    // Extract the info object
    final info = json['info'] ?? {};
    
    // Extract the results list
    var userList = json['results'] as List? ?? [];
    List<User> users = userList.map((user) => User.fromJson(user)).toList();

    return UserResponse(
      users: users,
      page: info['page'] ?? 1,
      seed: info['seed'] ?? '',
      results: info['results'] ?? 0,
      version: info['version'] ?? '',
    );
  }
}
