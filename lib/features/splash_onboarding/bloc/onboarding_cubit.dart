import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vgv/features/splash_onboarding/domain/repository/onboarding_repository.dart';

part 'onboarding_state.dart';

/// Cubit responsible for checking and completing the onboarding flow.
///
/// Call [checkOnboarding] once at startup to determine whether the onboarding
/// screen should be shown. Call [completeOnboarding] when the user finishes
/// the onboarding flow.
class OnboardingCubit extends Cubit<OnboardingState> {
  OnboardingCubit({required OnboardingRepository onboardingRepository})
    : _repository = onboardingRepository,
      super(const OnboardingInitial());

  final OnboardingRepository _repository;

  /// Reads the persisted flag and emits [OnboardingRequired] or
  /// [OnboardingComplete] accordingly.
  Future<void> checkOnboarding() async {
    final seen = _repository.hasSeenOnboarding();
    emit(seen ? const OnboardingComplete() : const OnboardingRequired());
  }

  /// Persists the completion flag and emits [OnboardingComplete].
  Future<void> completeOnboarding() async {
    await _repository.markOnboardingSeen();
    emit(const OnboardingComplete());
  }
}
