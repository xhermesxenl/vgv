import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vgv/features/local_storage/bloc/preferences_cubit.dart';
import 'package:vgv/features/local_storage/domain/repository/preferences_repository.dart';

class _MockPreferencesRepository extends Mock
    implements PreferencesRepository {}

void main() {
  late _MockPreferencesRepository repository;

  setUp(() {
    repository = _MockPreferencesRepository();
  });

  group('PreferencesCubit', () {
    group('initial state', () {
      test('is PreferencesState with system themeMode and null locale', () {
        final cubit = PreferencesCubit(preferencesRepository: repository);
        expect(cubit.state, const PreferencesState());
        cubit.close();
      });
    });

    group('loadPreferences', () {
      blocTest<PreferencesCubit, PreferencesState>(
        'emits system themeMode and null locale when nothing stored',
        setUp: () {
          when(
            () => repository.getInt(key: any(named: 'key')),
          ).thenReturn(null);
          when(
            () => repository.getString(key: any(named: 'key')),
          ).thenReturn(null);
        },
        build: () => PreferencesCubit(preferencesRepository: repository),
        act: (cubit) => cubit.loadPreferences(),
        expect: () => [const PreferencesState()],
      );

      blocTest<PreferencesCubit, PreferencesState>(
        'emits stored themeMode and locale',
        setUp: () {
          when(
            () => repository.getInt(key: any(named: 'key')),
          ).thenReturn(ThemeMode.dark.index);
          when(
            () => repository.getString(key: any(named: 'key')),
          ).thenReturn('fr');
        },
        build: () => PreferencesCubit(preferencesRepository: repository),
        act: (cubit) => cubit.loadPreferences(),
        expect: () => [
          const PreferencesState(
            themeMode: ThemeMode.dark,
            locale: Locale('fr'),
          ),
        ],
      );
    });

    group('setThemeMode', () {
      blocTest<PreferencesCubit, PreferencesState>(
        'persists and emits new themeMode',
        setUp: () {
          when(
            () => repository.setInt(
              key: any(named: 'key'),
              value: any(named: 'value'),
            ),
          ).thenAnswer((_) async {});
        },
        build: () => PreferencesCubit(preferencesRepository: repository),
        act: (cubit) => cubit.setThemeMode(ThemeMode.dark),
        expect: () => [const PreferencesState(themeMode: ThemeMode.dark)],
        verify: (_) {
          verify(
            () => repository.setInt(
              key: any(named: 'key'),
              value: ThemeMode.dark.index,
            ),
          ).called(1);
        },
      );
    });

    group('setLocale', () {
      blocTest<PreferencesCubit, PreferencesState>(
        'persists and emits new locale',
        setUp: () {
          when(
            () => repository.setString(
              key: any(named: 'key'),
              value: any(named: 'value'),
            ),
          ).thenAnswer((_) async {});
        },
        build: () => PreferencesCubit(preferencesRepository: repository),
        act: (cubit) => cubit.setLocale(const Locale('en')),
        expect: () => [const PreferencesState(locale: Locale('en'))],
        verify: (_) {
          verify(
            () => repository.setString(
              key: any(named: 'key'),
              value: 'en',
            ),
          ).called(1);
        },
      );

      blocTest<PreferencesCubit, PreferencesState>(
        'removes locale and emits null locale when called with null',
        setUp: () {
          when(
            () => repository.remove(key: any(named: 'key')),
          ).thenAnswer((_) async {});
        },
        seed: () => const PreferencesState(locale: Locale('fr')),
        build: () => PreferencesCubit(preferencesRepository: repository),
        act: (cubit) => cubit.setLocale(null),
        expect: () => [const PreferencesState()],
        verify: (_) {
          verify(() => repository.remove(key: any(named: 'key'))).called(1);
        },
      );
    });
  });

  group('PreferencesState', () {
    test('supports equality', () {
      expect(
        const PreferencesState(themeMode: ThemeMode.light),
        const PreferencesState(themeMode: ThemeMode.light),
      );
    });

    test('copyWith returns updated state', () {
      const state = PreferencesState();
      final updated = state.copyWith(themeMode: ThemeMode.dark);
      expect(updated.themeMode, ThemeMode.dark);
      expect(updated.locale, isNull);
    });

    test('copyWith clearLocale removes locale', () {
      const state = PreferencesState(locale: Locale('en'));
      final updated = state.copyWith(clearLocale: true);
      expect(updated.locale, isNull);
    });
  });
}
