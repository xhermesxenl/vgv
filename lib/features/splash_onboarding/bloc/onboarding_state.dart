part of 'onboarding_cubit.dart';

/// Base state for [OnboardingCubit].
sealed class OnboardingState extends Equatable {
  const OnboardingState();

  @override
  List<Object?> get props => [];
}

/// Initial state before [OnboardingCubit.checkOnboarding] has been called.
final class OnboardingInitial extends OnboardingState {
  const OnboardingInitial();
}

/// Emitted when the user has never completed the onboarding flow.
///
/// The router should redirect to the onboarding screen.
final class OnboardingRequired extends OnboardingState {
  const OnboardingRequired();
}

/// Emitted when the onboarding flow has already been completed,
/// or immediately after [OnboardingCubit.completeOnboarding] is called.
///
/// The router should redirect to the auth screen.
final class OnboardingComplete extends OnboardingState {
  const OnboardingComplete();
}
