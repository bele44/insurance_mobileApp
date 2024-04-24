import 'dart:convert';
import 'package:http/http.dart' as http;
import 'SignUpData.dart';
class AuthService {
  static const String baseUrl = 'backend-url';

  static Future<bool> signUp(SignUpData signUpData) async {
    final response = await http.post(
      Uri.parse('$baseUrl/signup'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(signUpData.toJson()),
    );

    if (response.statusCode == 200) {
     
      return true;
    } else {
      
      return false;
    }
  }
}
