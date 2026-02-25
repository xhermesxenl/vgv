import 'package:flutter_test/flutter_test.dart';
import 'package:local_storage_client/local_storage_client.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vgv/features/local_storage/data/repository/secure_storage_repository_impl.dart';

class _MockSecureStorageClient extends Mock implements SecureStorageClient {}

void main() {
  late _MockSecureStorageClient client;
  late SecureStorageRepositoryImpl repository;

  setUp(() {
    client = _MockSecureStorageClient();
    repository = SecureStorageRepositoryImpl(client: client);
  });

  group('SecureStorageRepositoryImpl', () {
    const key = 'test_key';
    const value = 'test_value';

    test('read delegates to client', () async {
      when(() => client.read(key: key)).thenAnswer((_) async => value);

      final result = await repository.read(key: key);

      expect(result, value);
      verify(() => client.read(key: key)).called(1);
    });

    test('write delegates to client', () async {
      when(() => client.write(key: key, value: value))
          .thenAnswer((_) async {});

      await repository.write(key: key, value: value);

      verify(() => client.write(key: key, value: value)).called(1);
    });

    test('delete delegates to client', () async {
      when(() => client.delete(key: key)).thenAnswer((_) async {});

      await repository.delete(key: key);

      verify(() => client.delete(key: key)).called(1);
    });

    test('deleteAll delegates to client', () async {
      when(() => client.deleteAll()).thenAnswer((_) async {});

      await repository.deleteAll();

      verify(() => client.deleteAll()).called(1);
    });

    test('containsKey delegates to client', () async {
      when(() => client.containsKey(key: key)).thenAnswer((_) async => true);

      final result = await repository.containsKey(key: key);

      expect(result, isTrue);
      verify(() => client.containsKey(key: key)).called(1);
    });
  });
}
