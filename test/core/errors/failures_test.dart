import 'package:flutter_test/flutter_test.dart';
import 'package:vgv/core/errors/errors.dart';

void main() {
  group('Failure', () {
    group('NetworkFailure', () {
      test('uses default message', () {
        const failure = NetworkFailure();
        expect(
          failure.message,
          'A network error occurred. Please check your connection.',
        );
      });

      test('accepts custom message', () {
        const failure = NetworkFailure(message: 'No internet');
        expect(failure.message, 'No internet');
      });

      test('supports equality', () {
        expect(const NetworkFailure(), const NetworkFailure());
      });

      test('instances with different messages are not equal', () {
        expect(
          const NetworkFailure(),
          isNot(const NetworkFailure(message: 'No internet')),
        );
      });
    });

    group('ServerFailure', () {
      test('stores message and statusCode', () {
        const failure = ServerFailure(message: 'Not found', statusCode: 404);
        expect(failure.message, 'Not found');
        expect(failure.statusCode, 404);
      });

      test('statusCode is nullable', () {
        const failure = ServerFailure(message: 'Internal error');
        expect(failure.statusCode, isNull);
      });

      test('supports equality with same message and statusCode', () {
        expect(
          const ServerFailure(message: 'Not found', statusCode: 404),
          const ServerFailure(message: 'Not found', statusCode: 404),
        );
      });

      test('not equal when statusCode differs', () {
        expect(
          const ServerFailure(message: 'Error', statusCode: 404),
          isNot(const ServerFailure(message: 'Error', statusCode: 500)),
        );
      });

      test('not equal when message differs', () {
        expect(
          const ServerFailure(message: 'Not found', statusCode: 404),
          isNot(const ServerFailure(message: 'Forbidden', statusCode: 404)),
        );
      });
    });

    group('AuthFailure', () {
      test('uses default message', () {
        const failure = AuthFailure();
        expect(
          failure.message,
          'An authentication error occurred. Please sign in again.',
        );
      });

      test('accepts custom message', () {
        const failure = AuthFailure(message: 'Session expired');
        expect(failure.message, 'Session expired');
      });

      test('supports equality', () {
        expect(const AuthFailure(), const AuthFailure());
      });
    });

    group('StorageFailure', () {
      test('uses default message', () {
        const failure = StorageFailure();
        expect(failure.message, 'A storage error occurred. Please try again.');
      });

      test('accepts custom message', () {
        const failure = StorageFailure(message: 'Write failed');
        expect(failure.message, 'Write failed');
      });

      test('supports equality', () {
        expect(const StorageFailure(), const StorageFailure());
      });
    });

    group('UnknownFailure', () {
      test('uses default message', () {
        const failure = UnknownFailure();
        expect(
          failure.message,
          'An unexpected error occurred. Please try again.',
        );
      });

      test('accepts custom message', () {
        const failure = UnknownFailure(message: 'Something went wrong');
        expect(failure.message, 'Something went wrong');
      });

      test('supports equality', () {
        expect(const UnknownFailure(), const UnknownFailure());
      });
    });

    group('cross-type inequality', () {
      test(
        'NetworkFailure and AuthFailure with same message are not equal',
        () {
          const message = 'error';
          expect(
            const NetworkFailure(message: message),
            isNot(const AuthFailure(message: message)),
          );
        },
      );

      test(
        'StorageFailure and UnknownFailure with same message are not equal',
        () {
          const message = 'error';
          expect(
            const StorageFailure(message: message),
            isNot(const UnknownFailure(message: message)),
          );
        },
      );
    });
  });
}
