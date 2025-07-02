import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';

class AuthRepository {
  final String baseUrl = 'https://dummyjson.com';
  UserModel? _currentUser;

  AuthRepository();

  Stream<UserModel?> get authStateChanges => Stream.value(_currentUser);

  Future<UserModel> signInWithEmailAndPassword({
    required String username,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': username, 'password': password}),
      );

      if (response.statusCode == 200) {
        _currentUser = UserModel.fromJson(jsonDecode(response.body));
        return _currentUser!;
      } else {
        throw Exception('Failed to sign in: ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to sign in: ${e.toString()}');
    }
  }

  // Note: DummyJSON doesn't support sign up, but we'll keep the method for compatibility
  Future<UserModel> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String username,
    required String firstName,
    required String lastName,
  }) async {
    throw UnimplementedError('Sign up is not supported by DummyJSON API');
  }

  Future<void> signOut() async {
    _currentUser = null;
  }

  UserModel? get currentUser => _currentUser;

  bool get isAuthenticated => _currentUser != null;
}
