import 'package:equatable/equatable.dart';

enum LoginStatus { initial, loading, success, failure }

enum AuthMode { signIn, signUp }

class LoginState extends Equatable {
  const LoginState({
    this.email = '',
    this.password = '',
    this.status = LoginStatus.initial,
    this.mode = AuthMode.signIn,
    this.errorMessage,
  });

  final String email;
  final String password;
  final LoginStatus status;
  final AuthMode mode;
  final String? errorMessage;

  LoginState copyWith({
    String? email,
    String? password,
    LoginStatus? status,
    AuthMode? mode,
    String? errorMessage,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      status: status ?? this.status,
      mode: mode ?? this.mode,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [email, password, status, mode, errorMessage];
}
