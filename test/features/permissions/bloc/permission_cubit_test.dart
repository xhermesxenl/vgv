import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vgv/features/permissions/bloc/permission_cubit.dart';
import 'package:vgv/features/permissions/domain/models/app_permission.dart';
import 'package:vgv/features/permissions/domain/models/app_permission_status.dart';
import 'package:vgv/features/permissions/domain/repository/permission_repository.dart';

class _MockPermissionRepository extends Mock implements PermissionRepository {}

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

/// Stubs all [AppPermission.values] check calls on [repository].
void _stubCheckAll(
  _MockPermissionRepository repository,
  AppPermissionStatus status,
) {
  for (final p in AppPermission.values) {
    when(() => repository.check(p)).thenAnswer((_) async => status);
  }
}

void main() {
  late _MockPermissionRepository repository;

  setUp(() {
    repository = _MockPermissionRepository();
  });

  group('PermissionCubit', () {
    group('initial state', () {
      test('statuses map is empty', () {
        final cubit = PermissionCubit(repository: repository);
        expect(cubit.state.statuses, isEmpty);
        cubit.close();
      });

      test('statusOf returns unknown for any permission', () {
        final cubit = PermissionCubit(repository: repository);
        expect(
          cubit.state.statusOf(AppPermission.camera),
          AppPermissionStatus.unknown,
        );
        cubit.close();
      });

      test('allGranted is false when statuses is empty', () {
        final cubit = PermissionCubit(repository: repository);
        expect(cubit.state.allGranted, isFalse);
        cubit.close();
      });
    });

    group('checkAll', () {
      blocTest<PermissionCubit, PermissionState>(
        'emits state with all permissions granted',
        setUp: () => _stubCheckAll(repository, AppPermissionStatus.granted),
        build: () => PermissionCubit(repository: repository),
        act: (cubit) => cubit.checkAll(),
        expect: () => [
          isA<PermissionState>().having(
            (s) => s.allGranted,
            'allGranted',
            isTrue,
          ),
        ],
      );

      blocTest<PermissionCubit, PermissionState>(
        'emits state with all permissions denied',
        setUp: () => _stubCheckAll(repository, AppPermissionStatus.denied),
        build: () => PermissionCubit(repository: repository),
        act: (cubit) => cubit.checkAll(),
        expect: () => [
          isA<PermissionState>().having(
            (s) => s.allGranted,
            'allGranted',
            isFalse,
          ),
        ],
      );

      blocTest<PermissionCubit, PermissionState>(
        'populates statusOf correctly for each permission',
        setUp: () {
          when(
            () => repository.check(AppPermission.camera),
          ).thenAnswer((_) async => AppPermissionStatus.granted);
          when(
            () => repository.check(AppPermission.photos),
          ).thenAnswer((_) async => AppPermissionStatus.denied);
          when(
            () => repository.check(AppPermission.notifications),
          ).thenAnswer((_) async => AppPermissionStatus.permanentlyDenied);
        },
        build: () => PermissionCubit(repository: repository),
        act: (cubit) => cubit.checkAll(),
        verify: (cubit) {
          expect(
            cubit.state.statusOf(AppPermission.camera),
            AppPermissionStatus.granted,
          );
          expect(
            cubit.state.statusOf(AppPermission.photos),
            AppPermissionStatus.denied,
          );
          expect(
            cubit.state.statusOf(AppPermission.notifications),
            AppPermissionStatus.permanentlyDenied,
          );
        },
      );
    });

    group('request', () {
      blocTest<PermissionCubit, PermissionState>(
        'emits granted status for requested permission',
        setUp: () {
          when(
            () => repository.request(AppPermission.camera),
          ).thenAnswer((_) async => AppPermissionStatus.granted);
        },
        build: () => PermissionCubit(repository: repository),
        act: (cubit) => cubit.request(AppPermission.camera),
        expect: () => [
          isA<PermissionState>().having(
            (s) => s.statusOf(AppPermission.camera),
            'camera status',
            AppPermissionStatus.granted,
          ),
        ],
      );

      blocTest<PermissionCubit, PermissionState>(
        'emits permanentlyDenied without affecting other permissions',
        setUp: () {
          when(
            () => repository.request(AppPermission.notifications),
          ).thenAnswer((_) async => AppPermissionStatus.permanentlyDenied);
        },
        build: () => PermissionCubit(repository: repository),
        act: (cubit) => cubit.request(AppPermission.notifications),
        verify: (cubit) {
          expect(
            cubit.state.statusOf(AppPermission.notifications),
            AppPermissionStatus.permanentlyDenied,
          );
          expect(
            cubit.state.statusOf(AppPermission.camera),
            AppPermissionStatus.unknown,
          );
        },
      );
    });

    group('requestAll', () {
      blocTest<PermissionCubit, PermissionState>(
        'requests each permission and emits a single state with all results',
        setUp: () {
          when(
            () => repository.request(AppPermission.camera),
          ).thenAnswer((_) async => AppPermissionStatus.granted);
          when(
            () => repository.request(AppPermission.photos),
          ).thenAnswer((_) async => AppPermissionStatus.denied);
        },
        build: () => PermissionCubit(repository: repository),
        act: (cubit) =>
            cubit.requestAll([AppPermission.camera, AppPermission.photos]),
        verify: (cubit) {
          expect(
            cubit.state.statusOf(AppPermission.camera),
            AppPermissionStatus.granted,
          );
          expect(
            cubit.state.statusOf(AppPermission.photos),
            AppPermissionStatus.denied,
          );
        },
      );
    });

    group('openSettings', () {
      test('delegates to repository', () async {
        when(() => repository.openSettings()).thenAnswer((_) async => true);

        final cubit = PermissionCubit(repository: repository);
        await cubit.openSettings();

        verify(() => repository.openSettings()).called(1);
        await cubit.close();
      });
    });

    group('PermissionState', () {
      test('supports value equality', () {
        const s1 = PermissionState();
        const s2 = PermissionState();
        expect(s1, equals(s2));
      });

      test('allGranted is true only when all permissions are granted', () {
        final state = PermissionState(
          statuses: {
            for (final p in AppPermission.values)
              p: AppPermissionStatus.granted,
          },
        );
        expect(state.allGranted, isTrue);
      });

      test('allGranted is false when one permission is denied', () {
        const state = PermissionState(
          statuses: {
            AppPermission.camera: AppPermissionStatus.granted,
            AppPermission.photos: AppPermissionStatus.denied,
            AppPermission.notifications: AppPermissionStatus.granted,
          },
        );
        expect(state.allGranted, isFalse);
      });

      test('copyWith preserves existing statuses when null passed', () {
        const original = PermissionState(
          statuses: {AppPermission.camera: AppPermissionStatus.granted},
        );
        final copy = original.copyWith();
        expect(copy, equals(original));
      });
    });
  });
}
