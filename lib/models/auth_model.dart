class AuthModel {
  final String? token;
  final String? error;
  final bool isAuthenticated;

  AuthModel({
    this.token,
    this.error,
    this.isAuthenticated = false,
  });

  factory AuthModel.authenticated(String token) {
    return AuthModel(
      token: token,
      isAuthenticated: true,
    );
  }

  factory AuthModel.error(String error) {
    return AuthModel(
      error: error,
      isAuthenticated: false,
    );
  }

  factory AuthModel.initial() {
    return AuthModel(
      isAuthenticated: false,
    );
  }
}

class UserCredentials {
  final String email;
  final String password;

  UserCredentials({
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
    };
  }
}
