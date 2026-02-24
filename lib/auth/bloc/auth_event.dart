import 'package:equatable/equatable.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

sealed class AuthEvent extends Equatable {
  const AuthEvent();
}

final class AuthStarted extends AuthEvent {
  const AuthStarted();

  @override
  List<Object?> get props => [];
}

/// Internal event emitted when the Supabase auth stream changes.
final class AuthUserChanged extends AuthEvent {
  const AuthUserChanged(this.authState);

  final supabase.AuthState authState;

  @override
  List<Object?> get props => [authState];
}

final class AuthSignOutRequested extends AuthEvent {
  const AuthSignOutRequested();

  @override
  List<Object?> get props => [];
}
