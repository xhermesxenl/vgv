import 'package:flutter_test/flutter_test.dart';
import 'package:local_storage_client/local_storage_client.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vgv/features/local_storage/data/repository/preferences_repository_impl.dart';

class _MockPreferencesClient extends Mock implements PreferencesClient {}

void main() {
  late _MockPreferencesClient client;
  late PreferencesRepositoryImpl repository;

  setUp(() {
    client = _MockPreferencesClient();
    repository = PreferencesRepositoryImpl(client: client);
  });

  group('PreferencesRepositoryImpl', () {
    const key = 'test_key';

    test('getString delegates to client', () {
      when(() => client.getString(key: key)).thenReturn('hello');

      final result = repository.getString(key: key);

      expect(result, 'hello');
      verify(() => client.getString(key: key)).called(1);
    });

    test('setString delegates to client', () async {
      when(() => client.setString(key: key, value: 'hello'))
          .thenAnswer((_) async {});

      await repository.setString(key: key, value: 'hello');

      verify(() => client.setString(key: key, value: 'hello')).called(1);
    });

    test('getBool delegates to client', () {
      when(() => client.getBool(key: key)).thenReturn(true);

      final result = repository.getBool(key: key);

      expect(result, isTrue);
      verify(() => client.getBool(key: key)).called(1);
    });

    test('setBool delegates to client', () async {
      when(() => client.setBool(key: key, value: true))
          .thenAnswer((_) async {});

      await repository.setBool(key: key, value: true);

      verify(() => client.setBool(key: key, value: true)).called(1);
    });

    test('getInt delegates to client', () {
      when(() => client.getInt(key: key)).thenReturn(42);

      final result = repository.getInt(key: key);

      expect(result, 42);
      verify(() => client.getInt(key: key)).called(1);
    });

    test('setInt delegates to client', () async {
      when(() => client.setInt(key: key, value: 42))
          .thenAnswer((_) async {});

      await repository.setInt(key: key, value: 42);

      verify(() => client.setInt(key: key, value: 42)).called(1);
    });

    test('remove delegates to client', () async {
      when(() => client.remove(key: key)).thenAnswer((_) async {});

      await repository.remove(key: key);

      verify(() => client.remove(key: key)).called(1);
    });

    test('containsKey delegates to client', () {
      when(() => client.containsKey(key: key)).thenReturn(true);

      final result = repository.containsKey(key: key);

      expect(result, isTrue);
      verify(() => client.containsKey(key: key)).called(1);
    });
  });
}
