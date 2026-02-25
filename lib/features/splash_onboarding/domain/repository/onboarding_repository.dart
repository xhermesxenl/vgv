/// Abstract interface for reading and writing the onboarding completion flag.
///
/// Implementations persist the flag via a local storage mechanism so that
/// the onboarding screen is shown only on the first app launch.
abstract class OnboardingRepository {
  /// Returns `true` if the user has already completed the onboarding flow.
  bool hasSeenOnboarding();

  /// Persists the flag indicating that the onboarding flow has been completed.
  Future<void> markOnboardingSeen();
}
