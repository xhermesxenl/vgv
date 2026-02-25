import 'package:flutter/material.dart';
import 'package:vgv/features/splash_onboarding/view/onboarding_view.dart';

/// Entry point for the onboarding flow.
///
/// Reads the cubit from the widget tree (provided in App) and
/// delegates rendering to [OnboardingView].
///
/// Navigation away from this screen is handled entirely by the router
/// redirect, which listens to cubit state changes. This page
/// does not call the router directly.
class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const OnboardingView();
  }
}
