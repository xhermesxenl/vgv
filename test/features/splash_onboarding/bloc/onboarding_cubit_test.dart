import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vgv/features/splash_onboarding/bloc/onboarding_cubit.dart';
import 'package:vgv/features/splash_onboarding/domain/repository/onboarding_repository.dart';

class _MockOnboardingRepository extends Mock implements OnboardingRepository {}

void main() {
  late _MockOnboardingRepository repository;

  setUp(() {
    repository = _MockOnboardingRepository();
  });

  group('OnboardingCubit', () {
    group('initial state', () {
      test('is OnboardingInitial', () {
        final cubit = OnboardingCubit(onboardingRepository: repository);
        expect(cubit.state, const OnboardingInitial());
        cubit.close();
      });
    });

    group('checkOnboarding', () {
      blocTest<OnboardingCubit, OnboardingState>(
        'emits OnboardingRequired when flag is false',
        setUp: () {
          when(() => repository.hasSeenOnboarding()).thenReturn(false);
        },
        build: () => OnboardingCubit(onboardingRepository: repository),
        act: (cubit) => cubit.checkOnboarding(),
        expect: () => [const OnboardingRequired()],
      );

      blocTest<OnboardingCubit, OnboardingState>(
        'emits OnboardingComplete when flag is true',
        setUp: () {
          when(() => repository.hasSeenOnboarding()).thenReturn(true);
        },
        build: () => OnboardingCubit(onboardingRepository: repository),
        act: (cubit) => cubit.checkOnboarding(),
        expect: () => [const OnboardingComplete()],
      );

      blocTest<OnboardingCubit, OnboardingState>(
        'calls hasSeenOnboarding exactly once',
        setUp: () {
          when(() => repository.hasSeenOnboarding()).thenReturn(false);
        },
        build: () => OnboardingCubit(onboardingRepository: repository),
        act: (cubit) => cubit.checkOnboarding(),
        verify: (_) {
          verify(() => repository.hasSeenOnboarding()).called(1);
        },
      );
    });

    group('completeOnboarding', () {
      blocTest<OnboardingCubit, OnboardingState>(
        'emits OnboardingComplete',
        setUp: () {
          when(() => repository.markOnboardingSeen()).thenAnswer((_) async {});
        },
        build: () => OnboardingCubit(onboardingRepository: repository),
        act: (cubit) => cubit.completeOnboarding(),
        expect: () => [const OnboardingComplete()],
      );

      blocTest<OnboardingCubit, OnboardingState>(
        'persists the flag before emitting',
        setUp: () {
          when(() => repository.markOnboardingSeen()).thenAnswer((_) async {});
        },
        build: () => OnboardingCubit(onboardingRepository: repository),
        act: (cubit) => cubit.completeOnboarding(),
        verify: (_) {
          verify(() => repository.markOnboardingSeen()).called(1);
        },
      );

      blocTest<OnboardingCubit, OnboardingState>(
        'emits OnboardingComplete even when already in OnboardingRequired',
        setUp: () {
          when(() => repository.hasSeenOnboarding()).thenReturn(false);
          when(() => repository.markOnboardingSeen()).thenAnswer((_) async {});
        },
        seed: () => const OnboardingRequired(),
        build: () => OnboardingCubit(onboardingRepository: repository),
        act: (cubit) => cubit.completeOnboarding(),
        expect: () => [const OnboardingComplete()],
      );
    });
  });

  group('OnboardingState', () {
    test('OnboardingInitial supports equality', () {
      expect(const OnboardingInitial(), const OnboardingInitial());
    });

    test('OnboardingRequired supports equality', () {
      expect(const OnboardingRequired(), const OnboardingRequired());
    });

    test('OnboardingComplete supports equality', () {
      expect(const OnboardingComplete(), const OnboardingComplete());
    });

    test('distinct states are not equal', () {
      expect(const OnboardingInitial(), isNot(const OnboardingRequired()));
      expect(const OnboardingRequired(), isNot(const OnboardingComplete()));
      expect(const OnboardingInitial(), isNot(const OnboardingComplete()));
    });
  });
}
