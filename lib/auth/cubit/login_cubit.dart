import 'package:bloc/bloc.dart';
import 'package:vgv/auth/cubit/login_state.dart';
import 'package:vgv/auth/repository/auth_repository.dart';
import 'package:vgv/core/errors/failures.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(const LoginState());

  final AuthRepository _authRepository;

  static final _emailRegex = RegExp(
    r'^[\w.+\-]+@[\w\-]+\.[a-zA-Z]{2,}$',
  );

  static String? _validateEmail(String email) {
    if (email.isEmpty) return 'Email is required';
    if (!_emailRegex.hasMatch(email)) return 'Enter a valid email address';
    return null;
  }

  static String? _validatePassword(
    String password, {
    required bool isSignUp,
  }) {
    if (password.isEmpty) return 'Password is required';
    if (isSignUp && password.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  void emailChanged(String email) {
    emit(
      state.copyWith(
        email: email,
        status: LoginStatus.initial,
        emailError: state.hasAttemptedSubmit ? _validateEmail(email) : null,
      ),
    );
  }

  void passwordChanged(String password) {
    emit(
      state.copyWith(
        password: password,
        status: LoginStatus.initial,
        passwordError: state.hasAttemptedSubmit
            ? _validatePassword(
                password,
                isSignUp: state.mode == AuthMode.signUp,
              )
            : null,
      ),
    );
  }

  void toggleMode() {
    final newMode =
        state.mode == AuthMode.signIn ? AuthMode.signUp : AuthMode.signIn;
    emit(
      state.copyWith(
        mode: newMode,
        status: LoginStatus.initial,
        errorMessage: null,
        passwordError: state.hasAttemptedSubmit
            ? _validatePassword(
                state.password,
                isSignUp: newMode == AuthMode.signUp,
              )
            : null,
      ),
    );
  }

  Future<void> submit() async {
    final emailError = _validateEmail(state.email);
    final passwordError = _validatePassword(
      state.password,
      isSignUp: state.mode == AuthMode.signUp,
    );

    if (emailError != null || passwordError != null) {
      emit(
        state.copyWith(
          hasAttemptedSubmit: true,
          emailError: emailError,
          passwordError: passwordError,
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        status: LoginStatus.loading,
        hasAttemptedSubmit: true,
        emailError: null,
        passwordError: null,
        errorMessage: null,
      ),
    );

    try {
      if (state.mode == AuthMode.signIn) {
        await _authRepository.signInWithPassword(state.email, state.password);
      } else {
        await _authRepository.signUp(state.email, state.password);
      }
      emit(state.copyWith(status: LoginStatus.success));
    } on AuthFailure catch (e) {
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
    await _signInWithOAuth(_authRepository.signInWithGoogle);
  }

  Future<void> signInWithGithub() async {
    await _signInWithOAuth(_authRepository.signInWithGithub);
  }

  Future<void> _signInWithOAuth(Future<void> Function() oauthMethod) async {
    emit(state.copyWith(status: LoginStatus.loading));
    try {
      await oauthMethod();
      emit(state.copyWith(status: LoginStatus.initial));
    } on AuthFailure catch (e) {
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
