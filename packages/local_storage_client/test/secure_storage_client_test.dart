import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:local_storage_client/local_storage_client.dart';
import 'package:mocktail/mocktail.dart';

class _MockFlutterSecureStorage extends Mock implements FlutterSecureStorage {}

void main() {
  late FlutterSecureStorage mockStorage;
  late SecureStorageClient client;

  setUp(() {
    mockStorage = _MockFlutterSecureStorage();
    client = SecureStorageClient(storage: mockStorage);
  });

  group('SecureStorageClient', () {
    const key = 'test_key';
    const value = 'test_value';

    test('read delegates to FlutterSecureStorage.read', () async {
      when(() => mockStorage.read(key: key)).thenAnswer((_) async => value);

      final result = await client.read(key: key);

      expect(result, equals(value));
      verify(() => mockStorage.read(key: key)).called(1);
    });

    test('read returns null when key is absent', () async {
      when(() => mockStorage.read(key: key)).thenAnswer((_) async => null);

      final result = await client.read(key: key);

      expect(result, isNull);
    });

    test('write delegates to FlutterSecureStorage.write', () async {
      when(
        () => mockStorage.write(key: key, value: value),
      ).thenAnswer((_) async {});

      await client.write(key: key, value: value);

      verify(() => mockStorage.write(key: key, value: value)).called(1);
    });

    test('delete delegates to FlutterSecureStorage.delete', () async {
      when(() => mockStorage.delete(key: key)).thenAnswer((_) async {});

      await client.delete(key: key);

      verify(() => mockStorage.delete(key: key)).called(1);
    });

    test('deleteAll delegates to FlutterSecureStorage.deleteAll', () async {
      when(() => mockStorage.deleteAll()).thenAnswer((_) async {});

      await client.deleteAll();

      verify(() => mockStorage.deleteAll()).called(1);
    });

    test('containsKey delegates to FlutterSecureStorage.containsKey', () async {
      when(
        () => mockStorage.containsKey(key: key),
      ).thenAnswer((_) async => true);

      final result = await client.containsKey(key: key);

      expect(result, isTrue);
      verify(() => mockStorage.containsKey(key: key)).called(1);
    });
  });
}
