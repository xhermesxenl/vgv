import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vgv/features/splash_onboarding/bloc/onboarding_cubit.dart';

/// Data model for a single onboarding step.
class _OnboardingStep {
  const _OnboardingStep({
    required this.icon,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final String title;
  final String description;
}

const _steps = [
  _OnboardingStep(
    icon: Icons.rocket_launch_outlined,
    title: 'Welcome',
    description:
        'This app is built on a solid VGV + Supabase foundation, '
        'ready to scale with your project.',
  ),
  _OnboardingStep(
    icon: Icons.lock_outline,
    title: 'Secure by default',
    description:
        'Authentication, encrypted storage and row-level security '
        'are set up out of the box.',
  ),
  _OnboardingStep(
    icon: Icons.tune_outlined,
    title: 'Fully customisable',
    description:
        'Replace any layer — theme, router, data sources — '
        'without touching the rest of the codebase.',
  ),
];

/// UI for the onboarding flow.
///
/// Renders a [PageView] with [_steps] pages and a "Get started" button on
/// the last page. Intermediate pages show a "Next" button.
///
/// Calls [OnboardingCubit.completeOnboarding] when the user finishes,
/// which triggers a router redirect to the auth screen.
class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  final _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onNext() {
    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _onGetStarted() {
    context.read<OnboardingCubit>().completeOnboarding();
  }

  @override
  Widget build(BuildContext context) {
    final isLastPage = _currentPage == _steps.length - 1;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _steps.length,
                onPageChanged: (index) => setState(() => _currentPage = index),
                itemBuilder: (context, index) =>
                    _OnboardingStepPage(step: _steps[index]),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                children: [
                  _PageIndicator(
                    count: _steps.length,
                    current: _currentPage,
                    color: colorScheme.primary,
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: isLastPage ? _onGetStarted : _onNext,
                      child: Text(isLastPage ? 'Get started' : 'Next'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardingStepPage extends StatelessWidget {
  const _OnboardingStepPage({required this.step});

  final _OnboardingStep step;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(step.icon, size: 96),
          const SizedBox(height: 32),
          Text(
            step.title,
            style: textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            step.description,
            style: textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _PageIndicator extends StatelessWidget {
  const _PageIndicator({
    required this.count,
    required this.current,
    required this.color,
  });

  final int count;
  final int current;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (index) {
        final isActive = index == current;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: isActive ? 24 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: isActive ? color : color.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }
}
