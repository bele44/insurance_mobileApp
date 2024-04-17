class SignUpData {
  final String email;
  final String password;

  SignUpData({required this.email, required this.password});

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
    };
  }
}
