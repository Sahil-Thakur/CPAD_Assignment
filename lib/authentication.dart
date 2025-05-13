import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

class Authentication extends ParseUser {
  Authentication({String? username, String? password, String? emailAddress})
    : super(username, password, emailAddress);

  Authentication.clone() : this();

  @override
  clone(Map<String, dynamic> map) => Authentication.clone()..fromJson(map);

  /// SHA-256 password hashing (optional, not used by default in Parse)
  String getHashedPassword(String password) {
    var bytes = utf8.encode(password);
    var digest = sha256.convert(bytes);
    return digest.toString();
  }

  /// Sign up new user
  Future<ParseResponse> employeeSignUp(
    String empEmail,
    String empPassword,
  ) async {
    final user = Authentication(
      username: empEmail,
      password: empPassword.trim(),
      emailAddress: empEmail,
    );
    return await user.signUp();
  }

  Future<ParseResponse> employeeLogin(String empEmail, String empPassword) {
    final user = ParseUser(empEmail, empPassword, empEmail);
    return user.login().then((response) {
      if (!response.success) {
        print('Login failed');
      }
      return response;
    });
  }

  /// Log out current user
  Future<bool> employeeLogout() async {
    final user = await ParseUser.currentUser();
    if (user != null) {
      await user.logout();
      print('Logged out successfully');
      return true;
    }
    print('Logging out failed');
    return false;
  }

  /// Check if user is logged in and session is valid
  Future<bool> isEmployeeLoggedIn() async {
    final user = await ParseUser.currentUser();
    if (user != null) {
      final response = await ParseUser.getCurrentUserFromServer(
        user.sessionToken,
      );
      return response?.success ?? false;
    }
    return false;
  }
}
