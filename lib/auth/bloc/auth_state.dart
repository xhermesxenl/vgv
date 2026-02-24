import 'package:equatable/equatable.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

sealed class AuthState extends Equatable {
  const AuthState();
}

final class AuthInitial extends AuthState {
  const AuthInitial();

  @override
  List<Object?> get props => [];
}

final class AuthAuthenticated extends AuthState {
  const AuthAuthenticated(this.user);

  final supabase.User user;

  @override
  List<Object?> get props => [user];
}

final class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();

  @override
  List<Object?> get props => [];
}
