import 'package:connectivity_client/connectivity_client.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:local_storage_client/local_storage_client.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vgv/app/app.dart';

class _MockSecureStorageClient extends Mock implements SecureStorageClient {}

class _MockConnectivityClient extends Mock implements ConnectivityClient {}

void main() {
  group('App', () {
    test('can be instantiated with required clients', () async {
      SharedPreferences.setMockInitialValues({});
      final preferencesClient = await PreferencesClient.create();
      final secureStorageClient = _MockSecureStorageClient();
      final connectivityClient = _MockConnectivityClient();

      expect(
        App(
          secureStorageClient: secureStorageClient,
          preferencesClient: preferencesClient,
          connectivityClient: connectivityClient,
        ),
        isA<App>(),
      );
    });
  });
}
