import 'package:flutter_test/flutter_test.dart';
import 'package:local_storage_client/local_storage_client.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late SharedPreferences mockPreferences;
  late PreferencesClient client;

  setUp(() {
    mockPreferences = _MockSharedPreferences();
    client = PreferencesClient(preferences: mockPreferences);
  });

  group('PreferencesClient', () {
    const key = 'test_key';

    group('getString', () {
      test('returns value when key exists', () {
        when(() => mockPreferences.getString(key)).thenReturn('hello');

        expect(client.getString(key: key), equals('hello'));
      });

      test('returns null when key is absent', () {
        when(() => mockPreferences.getString(key)).thenReturn(null);

        expect(client.getString(key: key), isNull);
      });
    });

    group('setString', () {
      test('delegates to SharedPreferences.setString', () async {
        when(
          () => mockPreferences.setString(key, 'hello'),
        ).thenAnswer((_) async => true);

        await client.setString(key: key, value: 'hello');

        verify(() => mockPreferences.setString(key, 'hello')).called(1);
      });
    });

    group('getBool', () {
      test('returns value when key exists', () {
        when(() => mockPreferences.getBool(key)).thenReturn(true);

        expect(client.getBool(key: key), isTrue);
      });

      test('returns null when key is absent', () {
        when(() => mockPreferences.getBool(key)).thenReturn(null);

        expect(client.getBool(key: key), isNull);
      });
    });

    group('setBool', () {
      test('delegates to SharedPreferences.setBool', () async {
        when(
          () => mockPreferences.setBool(key, true),
        ).thenAnswer((_) async => true);

        await client.setBool(key: key, value: true);

        verify(() => mockPreferences.setBool(key, true)).called(1);
      });
    });

    group('getInt', () {
      test('returns value when key exists', () {
        when(() => mockPreferences.getInt(key)).thenReturn(42);

        expect(client.getInt(key: key), equals(42));
      });

      test('returns null when key is absent', () {
        when(() => mockPreferences.getInt(key)).thenReturn(null);

        expect(client.getInt(key: key), isNull);
      });
    });

    group('setInt', () {
      test('delegates to SharedPreferences.setInt', () async {
        when(
          () => mockPreferences.setInt(key, 42),
        ).thenAnswer((_) async => true);

        await client.setInt(key: key, value: 42);

        verify(() => mockPreferences.setInt(key, 42)).called(1);
      });
    });

    group('remove', () {
      test('delegates to SharedPreferences.remove', () async {
        when(() => mockPreferences.remove(key)).thenAnswer((_) async => true);

        await client.remove(key: key);

        verify(() => mockPreferences.remove(key)).called(1);
      });
    });

    group('containsKey', () {
      test('returns true when key exists', () {
        when(() => mockPreferences.containsKey(key)).thenReturn(true);

        expect(client.containsKey(key: key), isTrue);
      });

      test('returns false when key is absent', () {
        when(() => mockPreferences.containsKey(key)).thenReturn(false);

        expect(client.containsKey(key: key), isFalse);
      });
    });
  });
}
