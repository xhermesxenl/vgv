import 'package:supabase_auth_client/src/auth_user.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

/// Low-level wrapper around the Supabase GoTrue auth client.
///
/// Translates Supabase auth primitives into domain types ([AuthUser]).
/// All Supabase types are confined to this class and [AuthUser.fromSupabase].
class AuthClient {
  /// Creates an [AuthClient].
  ///
  /// Provide [client] to inject a custom [supabase.SupabaseClient]
  /// (useful for testing). Defaults to [supabase.Supabase.instance.client].
  AuthClient({supabase.SupabaseClient? client})
      : _client = client ?? supabase.Supabase.instance.client;

  final supabase.SupabaseClient _client;

  /// Stream of [AuthUser] changes.
  ///
  /// Emits `null` when the user signs out or the session expires.
  Stream<AuthUser?> get authStateChanges =>
      _client.auth.onAuthStateChange.map((state) {
        final user = state.session?.user;
        return user == null ? null : AuthUser.fromSupabase(user);
      });

  /// Returns the currently authenticated [AuthUser], or `null`.
  AuthUser? get currentUser {
    final user = _client.auth.currentUser;
    return user == null ? null : AuthUser.fromSupabase(user);
  }

  /// Signs in with [email] and [password].
  ///
  /// Throws [supabase.AuthException] on failure.
  Future<void> signInWithPassword({
    required String email,
    required String password,
  }) async {
    await _client.auth.signInWithPassword(email: email, password: password);
  }

  /// Creates a new account with [email] and [password].
  ///
  /// Throws [supabase.AuthException] on failure.
  Future<void> signUp({
    required String email,
    required String password,
  }) async {
    await _client.auth.signUp(email: email, password: password);
  }

  /// Signs in via OAuth [provider] (e.g. Google, GitHub).
  ///
  /// Throws [supabase.AuthException] on failure.
  Future<void> signInWithOAuth(supabase.OAuthProvider provider) async {
    await _client.auth.signInWithOAuth(provider);
  }

  /// Signs out the current user.
  Future<void> signOut() async {
    await _client.auth.signOut();
  }
}
