import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../models/user_model.dart';
import '../repositories/auth_repository.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _repository;

  AuthCubit({required AuthRepository repository})
    : _repository = repository,
      super(const AuthInitial());

  Future<void> signIn(String username, String password) async {
    emit(const AuthLoading());
    try {
      final user = await _repository.signInWithEmailAndPassword(
        username: username,
        password: password,
      );
      emit(AuthSuccess('تم تسجيل الدخول بنجاح'));
      emit(AuthAuthenticated(user));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> signUp({
    required String email,
    required String password,
    required String username,
    required String firstName,
    required String lastName,
  }) async {
    emit(const AuthLoading());
    try {
      final user = await _repository.signUpWithEmailAndPassword(
        email: email,
        password: password,
        username: username,
        firstName: firstName,
        lastName: lastName,
      );
      emit(AuthSuccess('تم إنشاء الحساب بنجاح'));
      emit(AuthAuthenticated(user));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> signOut() async {
    try {
      await _repository.signOut();
      emit(const AuthUnauthenticated());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  void checkAuthState() {
    _repository.authStateChanges.listen((UserModel? user) {
      if (user != null) {
        emit(AuthAuthenticated(user));
      } else {
        emit(const AuthUnauthenticated());
      }
    });
  }
}
