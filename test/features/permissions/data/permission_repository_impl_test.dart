import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:permission_client/permission_client.dart';
import 'package:vgv/features/permissions/data/repository/permission_repository_impl.dart';
import 'package:vgv/features/permissions/domain/models/app_permission.dart';
import 'package:vgv/features/permissions/domain/models/app_permission_status.dart';

class _MockPermissionClient extends Mock implements PermissionClient {}

void main() {
  late _MockPermissionClient client;
  late PermissionRepositoryImpl repository;

  setUp(() {
    client = _MockPermissionClient();
    repository = PermissionRepositoryImpl(client: client);
  });

  group('PermissionRepositoryImpl', () {
    group('check', () {
      test('maps camera to Permission.camera and granted status', () async {
        when(() => client.check(Permission.camera))
            .thenAnswer((_) async => PermissionStatus.granted);

        final result = await repository.check(AppPermission.camera);

        expect(result, AppPermissionStatus.granted);
        verify(() => client.check(Permission.camera)).called(1);
      });

      test('maps photos to Permission.photos', () async {
        when(() => client.check(Permission.photos))
            .thenAnswer((_) async => PermissionStatus.denied);

        final result = await repository.check(AppPermission.photos);

        expect(result, AppPermissionStatus.denied);
        verify(() => client.check(Permission.photos)).called(1);
      });

      test('maps notifications to Permission.notification', () async {
        when(() => client.check(Permission.notification))
            .thenAnswer((_) async => PermissionStatus.permanentlyDenied);

        final result = await repository.check(AppPermission.notifications);

        expect(result, AppPermissionStatus.permanentlyDenied);
      });

      test('maps restricted status to permanentlyDenied', () async {
        when(() => client.check(Permission.camera))
            .thenAnswer((_) async => PermissionStatus.restricted);

        final result = await repository.check(AppPermission.camera);

        expect(result, AppPermissionStatus.permanentlyDenied);
      });

      test('maps unknown plugin status to denied', () async {
        when(() => client.check(Permission.camera))
            .thenAnswer((_) async => PermissionStatus.limited);

        final result = await repository.check(AppPermission.camera);

        expect(result, AppPermissionStatus.denied);
      });
    });

    group('request', () {
      test('requests camera permission and returns granted', () async {
        when(() => client.request(Permission.camera))
            .thenAnswer((_) async => PermissionStatus.granted);

        final result = await repository.request(AppPermission.camera);

        expect(result, AppPermissionStatus.granted);
        verify(() => client.request(Permission.camera)).called(1);
      });

      test('requests photos permission and returns denied', () async {
        when(() => client.request(Permission.photos))
            .thenAnswer((_) async => PermissionStatus.denied);

        final result = await repository.request(AppPermission.photos);

        expect(result, AppPermissionStatus.denied);
      });

      test('requests notification permission and returns permanentlyDenied',
          () async {
        when(() => client.request(Permission.notification))
            .thenAnswer((_) async => PermissionStatus.permanentlyDenied);

        final result = await repository.request(AppPermission.notifications);

        expect(result, AppPermissionStatus.permanentlyDenied);
      });
    });

    group('openSettings', () {
      test('delegates to client and returns true', () async {
        when(() => client.openSettings()).thenAnswer((_) async => true);

        final result = await repository.openSettings();

        expect(result, isTrue);
        verify(() => client.openSettings()).called(1);
      });

      test('returns false when client returns false', () async {
        when(() => client.openSettings()).thenAnswer((_) async => false);

        final result = await repository.openSettings();

        expect(result, isFalse);
      });
    });
  });
}
