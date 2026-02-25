import 'package:equatable/equatable.dart';

enum LoginStatus { initial, loading, success, failure }

enum AuthMode { signIn, signUp }

// Sentinel to distinguish "not provided" from "explicitly null" in copyWith.
const _kOmit = Object();

class LoginState extends Equatable {
  const LoginState({
    this.email = '',
    this.password = '',
    this.status = LoginStatus.initial,
    this.mode = AuthMode.signIn,
    this.errorMessage,
    this.emailError,
    this.passwordError,
    this.hasAttemptedSubmit = false,
  });

  final String email;
  final String password;
  final LoginStatus status;
  final AuthMode mode;
  final String? errorMessage;
  final String? emailError;
  final String? passwordError;
  final bool hasAttemptedSubmit;

  LoginState copyWith({
    String? email,
    String? password,
    LoginStatus? status,
    AuthMode? mode,
    Object? errorMessage = _kOmit,
    Object? emailError = _kOmit,
    Object? passwordError = _kOmit,
    bool? hasAttemptedSubmit,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      status: status ?? this.status,
      mode: mode ?? this.mode,
      // ignore: avoid_dynamic_calls
      errorMessage:
          errorMessage == _kOmit ? this.errorMessage : errorMessage as String?,
      // ignore: avoid_dynamic_calls
      emailError:
          emailError == _kOmit ? this.emailError : emailError as String?,
      // ignore: avoid_dynamic_calls
      passwordError: passwordError == _kOmit
          ? this.passwordError
          : passwordError as String?,
      hasAttemptedSubmit: hasAttemptedSubmit ?? this.hasAttemptedSubmit,
    );
  }

  @override
  List<Object?> get props => [
        email,
        password,
        status,
        mode,
        errorMessage,
        emailError,
        passwordError,
        hasAttemptedSubmit,
      ];
}
