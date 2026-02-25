import 'package:equatable/equatable.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

/// Domain model representing an authenticated user.
///
/// Wraps the minimal fields needed by the app layer so that
/// Supabase types never leak outside this package.
class AuthUser extends Equatable {
  const AuthUser({
    required this.id,
    required this.email,
    this.phone,
  });

  /// Creates an [AuthUser] from a [supabase.User].
  factory AuthUser.fromSupabase(supabase.User user) {
    return AuthUser(
      id: user.id,
      email: user.email ?? '',
      phone: user.phone,
    );
  }

  /// Unique identifier from Supabase auth.
  final String id;

  /// Primary email address.
  final String email;

  /// Phone number, if set.
  final String? phone;

  @override
  List<Object?> get props => [id, email, phone];
}
