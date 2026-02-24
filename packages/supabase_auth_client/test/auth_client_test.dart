import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_auth_client/supabase_auth_client.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

// ---------------------------------------------------------------------------
// Mocks
// ---------------------------------------------------------------------------

class _MockSupabaseClient extends Mock implements supabase.SupabaseClient {}

class _MockGoTrueClient extends Mock implements supabase.GoTrueClient {}

class _MockSupabaseUser extends Mock implements supabase.User {}

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

supabase.AuthState _authState({supabase.Session? session}) {
  return supabase.AuthState(supabase.AuthChangeEvent.signedIn, session);
}

supabase.Session _fakeSession(supabase.User user) {
  final session = _MockSession();
  when(() => session.user).thenReturn(user);
  return session;
}

class _MockSession extends Mock implements supabase.Session {}

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  late _MockSupabaseClient supabaseClient;
  late _MockGoTrueClient goTrueClient;
  late AuthClient authClient;

  setUp(() {
    supabaseClient = _MockSupabaseClient();
    goTrueClient = _MockGoTrueClient();
    when(() => supabaseClient.auth).thenReturn(goTrueClient);
    authClient = AuthClient(client: supabaseClient);
  });

  group('AuthClient', () {
    group('currentUser', () {
      test('returns null when no user is signed in', () {
        when(() => goTrueClient.currentUser).thenReturn(null);
        expect(authClient.currentUser, isNull);
      });

      test('returns AuthUser when user is signed in', () {
        final user = _MockSupabaseUser();
        when(() => user.id).thenReturn('abc-123');
        when(() => user.email).thenReturn('test@test.com');
        when(() => user.phone).thenReturn(null);
        when(() => goTrueClient.currentUser).thenReturn(user);

        final result = authClient.currentUser;

        expect(result, isNotNull);
        expect(result!.id, 'abc-123');
        expect(result.email, 'test@test.com');
        expect(result.phone, isNull);
      });
    });

    group('authStateChanges', () {
      test('emits null when session is null', () async {
        final controller = StreamController<supabase.AuthState>();
        when(() => goTrueClient.onAuthStateChange)
            .thenAnswer((_) => controller.stream);

        final stream = authClient.authStateChanges;
        final future = expectLater(stream, emits(isNull));

        controller.add(_authState());

        await future;
        await controller.close();
      });

      test('emits AuthUser when session has a user', () async {
        final user = _MockSupabaseUser();
        when(() => user.id).thenReturn('user-1');
        when(() => user.email).thenReturn('a@a.fr');
        when(() => user.phone).thenReturn(null);

        final session = _fakeSession(user);
        final controller = StreamController<supabase.AuthState>();
        when(() => goTrueClient.onAuthStateChange)
            .thenAnswer((_) => controller.stream);

        final stream = authClient.authStateChanges;
        final future = expectLater(
          stream,
          emits(
            isA<AuthUser>()
                .having((u) => u.id, 'id', 'user-1')
                .having((u) => u.email, 'email', 'a@a.fr'),
          ),
        );

        controller.add(
          supabase.AuthState(supabase.AuthChangeEvent.signedIn, session),
        );

        await future;
        await controller.close();
      });
    });

    group('signInWithPassword', () {
      test('calls GoTrueClient.signInWithPassword with correct args', () async {
        when(
          () => goTrueClient.signInWithPassword(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) async => supabase.AuthResponse());

        await authClient.signInWithPassword(
          email: 'a@a.fr',
          password: '1234',
        );

        verify(
          () => goTrueClient.signInWithPassword(
            email: 'a@a.fr',
            password: '1234',
          ),
        ).called(1);
      });

      test('rethrows AuthException on failure', () {
        when(
          () => goTrueClient.signInWithPassword(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenThrow(
          const supabase.AuthException('Invalid credentials'),
        );

        expect(
          () => authClient.signInWithPassword(
            email: 'bad@test.com',
            password: 'wrong',
          ),
          throwsA(isA<supabase.AuthException>()),
        );
      });
    });

    group('signUp', () {
      test('calls GoTrueClient.signUp with correct args', () async {
        when(
          () => goTrueClient.signUp(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) async => supabase.AuthResponse());

        await authClient.signUp(email: 'new@test.com', password: 'pass123');

        verify(
          () => goTrueClient.signUp(
            email: 'new@test.com',
            password: 'pass123',
          ),
        ).called(1);
      });
    });

    group('signOut', () {
      test('calls GoTrueClient.signOut', () async {
        when(() => goTrueClient.signOut()).thenAnswer((_) async {});

        await authClient.signOut();

        verify(() => goTrueClient.signOut()).called(1);
      });
    });
  });

  group('AuthUser', () {
    test('supports value equality', () {
      const user1 = AuthUser(id: '1', email: 'a@a.fr');
      const user2 = AuthUser(id: '1', email: 'a@a.fr');
      expect(user1, equals(user2));
    });

    test('props includes id, email and phone', () {
      const user = AuthUser(id: '1', email: 'a@a.fr', phone: '0600');
      expect(user.props, ['1', 'a@a.fr', '0600']);
    });

    test('fromSupabase maps fields correctly', () {
      final supabaseUser = _MockSupabaseUser();
      when(() => supabaseUser.id).thenReturn('xyz');
      when(() => supabaseUser.email).thenReturn('x@y.com');
      when(() => supabaseUser.phone).thenReturn('0612');

      final user = AuthUser.fromSupabase(supabaseUser);

      expect(user.id, 'xyz');
      expect(user.email, 'x@y.com');
      expect(user.phone, '0612');
    });

    test('fromSupabase uses empty string when email is null', () {
      final supabaseUser = _MockSupabaseUser();
      when(() => supabaseUser.id).thenReturn('no-email');
      when(() => supabaseUser.email).thenReturn(null);
      when(() => supabaseUser.phone).thenReturn(null);

      final user = AuthUser.fromSupabase(supabaseUser);

      expect(user.email, equals(''));
    });
  });
}
