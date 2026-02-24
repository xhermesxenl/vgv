import 'package:bloc/bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:vgv/auth/cubit/login_state.dart';
import 'package:vgv/auth/repository/auth_repository.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(const LoginState());

  final AuthRepository _authRepository;

  void emailChanged(String email) {
    emit(state.copyWith(email: email, status: LoginStatus.initial));
  }

  void passwordChanged(String password) {
    emit(state.copyWith(password: password, status: LoginStatus.initial));
  }

  void toggleMode() {
    emit(
      state.copyWith(
        mode: state.mode == AuthMode.signIn ? AuthMode.signUp : AuthMode.signIn,
        status: LoginStatus.initial,
      ),
    );
  }

  Future<void> submit() async {
    if (state.email.isEmpty || state.password.isEmpty) {
      emit(
        state.copyWith(
          status: LoginStatus.failure,
          errorMessage: 'Email and password are required.',
        ),
      );
      return;
    }

    emit(state.copyWith(status: LoginStatus.loading));
    try {
      if (state.mode == AuthMode.signIn) {
        await _authRepository.signInWithPassword(state.email, state.password);
      } else {
        await _authRepository.signUp(state.email, state.password);
      }
      emit(state.copyWith(status: LoginStatus.success));
    } on AuthException catch (e) {
      emit(
        state.copyWith(
          status: LoginStatus.failure,
          errorMessage: e.message,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: LoginStatus.failure,
          errorMessage: 'An unexpected error occurred.',
        ),
      );
    }
  }

  Future<void> signInWithGoogle() async {
    await _signInWithOAuth(OAuthProvider.google);
  }

  Future<void> signInWithGithub() async {
    await _signInWithOAuth(OAuthProvider.github);
  }

  Future<void> _signInWithOAuth(OAuthProvider provider) async {
    emit(state.copyWith(status: LoginStatus.loading));
    try {
      await _authRepository.signInWithOAuth(provider);
      // Browser has opened; auth completion is handled by onAuthStateChange.
      emit(state.copyWith(status: LoginStatus.initial));
    } on AuthException catch (e) {
      emit(
        state.copyWith(
          status: LoginStatus.failure,
          errorMessage: e.message,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: LoginStatus.failure,
          errorMessage: 'An unexpected error occurred.',
        ),
      );
    }
  }
}
