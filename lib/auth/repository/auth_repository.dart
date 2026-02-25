import 'package:supabase_auth_client/supabase_auth_client.dart';
import 'package:supabase_flutter/supabase_flutter.dart'
    show AuthException, OAuthProvider;
import 'package:vgv/core/errors/failures.dart';

export 'package:supabase_auth_client/supabase_auth_client.dart' show AuthUser;

/// Domain-level auth repository.
///
/// Delegates all Supabase operations to [AuthClient] from
/// `packages/supabase_auth_client`, keeping `supabase_flutter` out of `lib/`.
///
/// [AuthException] is caught here and converted to [AuthFailure] so that
/// callers (Cubit/Bloc) never depend on Supabase types.
///
/// [OAuthProvider] is confined to this class — callers use named methods
/// (e.g. [signInWithGoogle]) so they never reference Supabase types directly.
class AuthRepository {
  AuthRepository({AuthClient? authClient})
      : _client = authClient ?? AuthClient();

  final AuthClient _client;

  /// Stream of [AuthUser] changes. Emits `null` on sign-out.
  Stream<AuthUser?> get authStateChanges => _client.authStateChanges;

  /// Returns the currently signed-in [AuthUser], or `null`.
  AuthUser? get currentUser => _client.currentUser;

  /// Signs in with [email] and [password].
  ///
  /// Throws [AuthFailure] on Supabase auth error.
  Future<void> signInWithPassword(String email, String password) async {
    try {
      await _client.signInWithPassword(email: email, password: password);
    } on AuthException catch (e) {
      throw AuthFailure(message: e.message);
    }
  }

  /// Creates a new account with [email] and [password].
  ///
  /// Throws [AuthFailure] on Supabase auth error.
  Future<void> signUp(String email, String password) async {
    try {
      await _client.signUp(email: email, password: password);
    } on AuthException catch (e) {
      throw AuthFailure(message: e.message);
    }
  }

  /// Signs in with Google via OAuth.
  ///
  /// Throws [AuthFailure] on Supabase auth error.
  Future<void> signInWithGoogle() async {
    await _signInWithOAuth(OAuthProvider.google);
  }

  /// Signs in with GitHub via OAuth.
  ///
  /// Throws [AuthFailure] on Supabase auth error.
  Future<void> signInWithGithub() async {
    await _signInWithOAuth(OAuthProvider.github);
  }

  /// Signs out the current user.
  Future<void> signOut() async {
    await _client.signOut();
  }

  Future<void> _signInWithOAuth(OAuthProvider provider) async {
    try {
      await _client.signInWithOAuth(provider);
    } on AuthException catch (e) {
      throw AuthFailure(message: e.message);
    }
  }
}
