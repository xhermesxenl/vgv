import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vgv/core/errors/errors.dart';
import 'package:vgv/features/error_handler/bloc/error_handler_cubit.dart';
import 'package:vgv/features/error_handler/domain/model/app_error.dart';

void main() {
  group('ErrorHandlerCubit', () {
    group('initial state', () {
      test('has no active error', () {
        final cubit = ErrorHandlerCubit();
        expect(cubit.state, const ErrorHandlerState());
        expect(cubit.state.error, isNull);
        expect(cubit.state.hasError, isFalse);
        cubit.close();
      });
    });

    group('report', () {
      blocTest<ErrorHandlerCubit, ErrorHandlerState>(
        'emits warning AppError for NetworkFailure by default',
        build: ErrorHandlerCubit.new,
        act: (cubit) => cubit.report(const NetworkFailure()),
        expect: () => [
          const ErrorHandlerState(error: AppError(failure: NetworkFailure())),
        ],
      );

      blocTest<ErrorHandlerCubit, ErrorHandlerState>(
        'emits critical AppError when severity is critical',
        build: ErrorHandlerCubit.new,
        act: (cubit) => cubit.report(
          const ServerFailure(message: 'Forbidden', statusCode: 403),
          severity: ErrorSeverity.critical,
        ),
        expect: () => [
          const ErrorHandlerState(
            error: AppError(
              failure: ServerFailure(message: 'Forbidden', statusCode: 403),
              severity: ErrorSeverity.critical,
            ),
          ),
        ],
      );

      blocTest<ErrorHandlerCubit, ErrorHandlerState>(
        'emits warning AppError for AuthFailure',
        build: ErrorHandlerCubit.new,
        act: (cubit) => cubit.report(const AuthFailure()),
        expect: () => [
          const ErrorHandlerState(error: AppError(failure: AuthFailure())),
        ],
      );

      blocTest<ErrorHandlerCubit, ErrorHandlerState>(
        'emits warning AppError for StorageFailure',
        build: ErrorHandlerCubit.new,
        act: (cubit) => cubit.report(const StorageFailure()),
        expect: () => [
          const ErrorHandlerState(error: AppError(failure: StorageFailure())),
        ],
      );

      blocTest<ErrorHandlerCubit, ErrorHandlerState>(
        'emits warning AppError for UnknownFailure',
        build: ErrorHandlerCubit.new,
        act: (cubit) => cubit.report(const UnknownFailure()),
        expect: () => [
          const ErrorHandlerState(error: AppError(failure: UnknownFailure())),
        ],
      );

      blocTest<ErrorHandlerCubit, ErrorHandlerState>(
        'successive reports each emit a new state',
        build: ErrorHandlerCubit.new,
        act: (cubit) => cubit
          ..report(const NetworkFailure())
          ..report(const AuthFailure()),
        expect: () => [
          const ErrorHandlerState(error: AppError(failure: NetworkFailure())),
          const ErrorHandlerState(error: AppError(failure: AuthFailure())),
        ],
      );
    });

    group('clear', () {
      blocTest<ErrorHandlerCubit, ErrorHandlerState>(
        'emits idle state after an active error',
        build: ErrorHandlerCubit.new,
        act: (cubit) => cubit
          ..report(const NetworkFailure())
          ..clear(),
        expect: () => [
          const ErrorHandlerState(error: AppError(failure: NetworkFailure())),
          const ErrorHandlerState(),
        ],
      );

      blocTest<ErrorHandlerCubit, ErrorHandlerState>(
        'emits idle state when called on already idle state',
        build: ErrorHandlerCubit.new,
        act: (cubit) => cubit.clear(),
        expect: () => [const ErrorHandlerState()],
      );
    });
  });

  group('ErrorHandlerState', () {
    test('supports equality when both idle', () {
      expect(const ErrorHandlerState(), const ErrorHandlerState());
    });

    test('supports equality with same AppError', () {
      const error = AppError(failure: NetworkFailure());
      expect(
        const ErrorHandlerState(error: error),
        const ErrorHandlerState(error: error),
      );
    });

    test('not equal when errors differ', () {
      expect(
        const ErrorHandlerState(error: AppError(failure: NetworkFailure())),
        isNot(const ErrorHandlerState(error: AppError(failure: AuthFailure()))),
      );
    });

    test('hasError is true when error is set', () {
      const state = ErrorHandlerState(
        error: AppError(failure: NetworkFailure()),
      );
      expect(state.hasError, isTrue);
    });

    test('hasError is false when error is null', () {
      const state = ErrorHandlerState();
      expect(state.hasError, isFalse);
    });
  });

  group('AppError', () {
    test('userMessage delegates to failure.message', () {
      const appError = AppError(
        failure: NetworkFailure(message: 'Custom network error'),
      );
      expect(appError.userMessage, 'Custom network error');
    });

    test('default severity is warning', () {
      const appError = AppError(failure: NetworkFailure());
      expect(appError.severity, ErrorSeverity.warning);
    });

    test('supports equality', () {
      expect(
        const AppError(failure: NetworkFailure()),
        const AppError(failure: NetworkFailure()),
      );
    });

    test('not equal when severity differs', () {
      expect(
        const AppError(failure: NetworkFailure()),
        isNot(
          const AppError(
            failure: NetworkFailure(),
            severity: ErrorSeverity.critical,
          ),
        ),
      );
    });

    test('not equal when failure differs', () {
      expect(
        const AppError(failure: NetworkFailure()),
        isNot(const AppError(failure: AuthFailure())),
      );
    });
  });
}
