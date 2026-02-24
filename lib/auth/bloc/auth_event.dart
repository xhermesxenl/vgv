import 'package:equatable/equatable.dart';
import 'package:supabase_auth_client/supabase_auth_client.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();
}

final class AuthStarted extends AuthEvent {
  const AuthStarted();

  @override
  List<Object?> get props => [];
}

/// Emitted internally when the auth stream emits a new [AuthUser] (or `null`).
final class AuthUserChanged extends AuthEvent {
  const AuthUserChanged(this.user);

  final AuthUser? user;

  @override
  List<Object?> get props => [user];
}

final class AuthSignOutRequested extends AuthEvent {
  const AuthSignOutRequested();

  @override
  List<Object?> get props => [];
}
