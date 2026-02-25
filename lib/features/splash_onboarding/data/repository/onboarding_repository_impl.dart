import 'package:vgv/features/local_storage/domain/repository/preferences_repository.dart';
import 'package:vgv/features/splash_onboarding/domain/repository/onboarding_repository.dart';

/// SharedPreferences key for the onboarding completion flag.
const _kOnboardingSeenKey = 'onboarding_seen';

/// [OnboardingRepository] implementation backed by [PreferencesRepository].
class OnboardingRepositoryImpl implements OnboardingRepository {
  const OnboardingRepositoryImpl({
    required PreferencesRepository preferencesRepository,
  }) : _preferences = preferencesRepository;

  final PreferencesRepository _preferences;

  @override
  bool hasSeenOnboarding() =>
      _preferences.getBool(key: _kOnboardingSeenKey) ?? false;

  @override
  Future<void> markOnboardingSeen() =>
      _preferences.setBool(key: _kOnboardingSeenKey, value: true);
}
