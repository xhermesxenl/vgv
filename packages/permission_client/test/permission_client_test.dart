import 'package:flutter_test/flutter_test.dart';
import 'package:permission_client/permission_client.dart';

void main() {
  group('PermissionClient', () {
    group('check', () {
      test('returns the status provided by checkPermission callback', () async {
        final client = PermissionClient(
          checkPermission: (_) async => PermissionStatus.granted,
          requestPermission: (_) async => PermissionStatus.denied,
          openAppSettings: () async => false,
        );

        final status = await client.check(Permission.camera);

        expect(status, PermissionStatus.granted);
      });

      test('returns denied when checkPermission returns denied', () async {
        final client = PermissionClient(
          checkPermission: (_) async => PermissionStatus.denied,
          requestPermission: (_) async => PermissionStatus.granted,
          openAppSettings: () async => false,
        );

        final status = await client.check(Permission.camera);

        expect(status, PermissionStatus.denied);
      });

      test('passes the correct Permission to the callback', () async {
        Permission? captured;
        final client = PermissionClient(
          checkPermission: (p) async {
            captured = p;
            return PermissionStatus.granted;
          },
          requestPermission: (_) async => PermissionStatus.denied,
          openAppSettings: () async => false,
        );

        await client.check(Permission.microphone);

        expect(captured, Permission.microphone);
      });
    });

    group('request', () {
      test('returns granted when requestPermission callback returns granted',
          () async {
        final client = PermissionClient(
          checkPermission: (_) async => PermissionStatus.denied,
          requestPermission: (_) async => PermissionStatus.granted,
          openAppSettings: () async => false,
        );

        final status = await client.request(Permission.camera);

        expect(status, PermissionStatus.granted);
      });

      test('returns permanentlyDenied when user permanently denies', () async {
        final client = PermissionClient(
          checkPermission: (_) async => PermissionStatus.denied,
          requestPermission: (_) async => PermissionStatus.permanentlyDenied,
          openAppSettings: () async => false,
        );

        final status = await client.request(Permission.notification);

        expect(status, PermissionStatus.permanentlyDenied);
      });

      test('passes the correct Permission to the callback', () async {
        Permission? captured;
        final client = PermissionClient(
          checkPermission: (_) async => PermissionStatus.denied,
          requestPermission: (p) async {
            captured = p;
            return PermissionStatus.granted;
          },
          openAppSettings: () async => false,
        );

        await client.request(Permission.photos);

        expect(captured, Permission.photos);
      });
    });

    group('openSettings', () {
      test('returns true when settings opened successfully', () async {
        final client = PermissionClient(
          checkPermission: (_) async => PermissionStatus.denied,
          requestPermission: (_) async => PermissionStatus.denied,
          openAppSettings: () async => true,
        );

        final result = await client.openSettings();

        expect(result, isTrue);
      });

      test('returns false when settings could not be opened', () async {
        final client = PermissionClient(
          checkPermission: (_) async => PermissionStatus.denied,
          requestPermission: (_) async => PermissionStatus.denied,
          openAppSettings: () async => false,
        );

        final result = await client.openSettings();

        expect(result, isFalse);
      });
    });
  });
}
