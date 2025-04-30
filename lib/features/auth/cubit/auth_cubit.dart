import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../repositories/auth_repository.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _repository;

  AuthCubit({required AuthRepository repository})
    : _repository = repository,
      super(const AuthInitial());

  Future<void> signIn(String email, String password) async {
    emit(const AuthLoading());
    try {
      await _repository.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      emit(const AuthSuccess('تم تسجيل الدخول بنجاح'));
      emit(const AuthAuthenticated());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> signUp(String email, String password) async {
    emit(const AuthLoading());
    try {
      await _repository.signUpWithEmailAndPassword(
        email: email,
        password: password,
      );
      emit(const AuthSuccess('تم إنشاء الحساب بنجاح'));
      emit(const AuthAuthenticated());
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
    _repository.authStateChanges.listen((User? user) {
      if (user != null) {
        emit(const AuthAuthenticated());
      } else {
        emit(const AuthUnauthenticated());
      }
    });
  }
}
