import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vgv/features/local_storage/domain/repository/preferences_repository.dart';
import 'package:vgv/features/splash_onboarding/data/repository/onboarding_repository_impl.dart';

class _MockPreferencesRepository extends Mock
    implements PreferencesRepository {}

void main() {
  late _MockPreferencesRepository preferences;
  late OnboardingRepositoryImpl repository;

  setUp(() {
    preferences = _MockPreferencesRepository();
    repository = OnboardingRepositoryImpl(
      preferencesRepository: preferences,
    );
  });

  group('OnboardingRepositoryImpl', () {
    group('hasSeenOnboarding', () {
      test('returns false when flag is absent', () {
        when(() => preferences.getBool(key: any(named: 'key')))
            .thenReturn(null);

        expect(repository.hasSeenOnboarding(), isFalse);
      });

      test('returns false when flag is explicitly false', () {
        when(() => preferences.getBool(key: any(named: 'key')))
            .thenReturn(false);

        expect(repository.hasSeenOnboarding(), isFalse);
      });

      test('returns true when flag is true', () {
        when(() => preferences.getBool(key: any(named: 'key')))
            .thenReturn(true);

        expect(repository.hasSeenOnboarding(), isTrue);
      });

      test('delegates to PreferencesRepository with correct key', () {
        when(() => preferences.getBool(key: any(named: 'key')))
            .thenReturn(true);

        repository.hasSeenOnboarding();

        verify(
          () => preferences.getBool(key: 'onboarding_seen'),
        ).called(1);
      });
    });

    group('markOnboardingSeen', () {
      test('delegates to PreferencesRepository with correct key and value',
          () async {
        when(
          () => preferences.setBool(
            key: any(named: 'key'),
            value: any(named: 'value'),
          ),
        ).thenAnswer((_) async {});

        await repository.markOnboardingSeen();

        verify(
          () => preferences.setBool(key: 'onboarding_seen', value: true),
        ).called(1);
      });
    });
  });
}
