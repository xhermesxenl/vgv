import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vgv/auth/auth.dart';
import 'package:vgv/features/splash_onboarding/bloc/onboarding_cubit.dart';
import 'package:vgv/features/splash_onboarding/view/onboarding_page.dart';
import 'package:vgv/home/view/home_page.dart';

/// All named route paths used by [GoRouter].
abstract final class AppRoutes {
  static const splash = '/';
  static const onboarding = '/onboarding';
  static const auth = '/auth';
  static const home = '/home';
}

/// Creates the app [GoRouter] instance.
///
/// Redirect priority:
/// 1. [AuthInitial] — always hold on [AppRoutes.splash].
/// 2. [AuthAuthenticated] — always go to [AppRoutes.home].
/// 3. [AuthUnauthenticated] + [OnboardingInitial] — hold on
///    [AppRoutes.splash] until [OnboardingCubit.checkOnboarding] resolves.
/// 4. [AuthUnauthenticated] + [OnboardingRequired] — go to
///    [AppRoutes.onboarding].
/// 5. [AuthUnauthenticated] + [OnboardingComplete] — go to [AppRoutes.auth].
GoRouter createRouter(AuthBloc authBloc, OnboardingCubit onboardingCubit) {
  return GoRouter(
    initialLocation: AppRoutes.splash,
    refreshListenable: _GoRouterRefreshStream([
      authBloc.stream,
      onboardingCubit.stream,
    ]),
    redirect: (context, state) {
      final authState = authBloc.state;
      final onboardingState = onboardingCubit.state;
      final location = state.uri.path;

      // While auth is resolving, stay on splash.
      if (authState is AuthInitial) {
        return location == AppRoutes.splash ? null : AppRoutes.splash;
      }

      // Authenticated users always go to home.
      if (authState is AuthAuthenticated) {
        if (location == AppRoutes.home) return null;
        return AppRoutes.home;
      }

      // --- AuthUnauthenticated from here ---

      // While onboarding check is pending, stay on splash.
      if (onboardingState is OnboardingInitial) {
        return location == AppRoutes.splash ? null : AppRoutes.splash;
      }

      // First launch: show onboarding.
      if (onboardingState is OnboardingRequired) {
        return location == AppRoutes.onboarding ? null : AppRoutes.onboarding;
      }

      // Onboarding done: show auth.
      // OnboardingComplete is the only remaining sealed case.
      if (location == AppRoutes.auth) return null;
      return AppRoutes.auth;
    },
    routes: [
      GoRoute(path: AppRoutes.splash, builder: (_, __) => const _SplashPage()),
      GoRoute(
        path: AppRoutes.onboarding,
        builder: (_, __) => const OnboardingPage(),
      ),
      GoRoute(path: AppRoutes.auth, builder: (_, __) => const AuthPage()),
      GoRoute(path: AppRoutes.home, builder: (_, __) => const HomePage()),
    ],
  );
}

class _SplashPage extends StatelessWidget {
  const _SplashPage();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}

/// Listens to multiple streams and notifies [GoRouter] on any emission.
class _GoRouterRefreshStream extends ChangeNotifier {
  _GoRouterRefreshStream(List<Stream<dynamic>> streams) {
    notifyListeners();
    _subscriptions = streams
        .map((s) => s.listen((_) => notifyListeners()))
        .toList();
  }

  late final List<StreamSubscription<dynamic>> _subscriptions;

  @override
  void dispose() {
    for (final sub in _subscriptions) {
      sub.cancel();
    }
    super.dispose();
  }
}
