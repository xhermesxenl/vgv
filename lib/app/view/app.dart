import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vgv/auth/auth.dart';
import 'package:vgv/home/home.dart';
import 'package:vgv/l10n/l10n.dart';
import 'package:vgv/users/repository/user_repository.dart';

class App extends StatelessWidget {
  const App({super.key, UserRepository? userRepository})
      : _userRepository = userRepository;

  final UserRepository? _userRepository;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthRepository>(
          create: (_) => AuthRepository(),
        ),
        RepositoryProvider<UserRepository>(
          create: (_) => _userRepository ?? UserRepository(),
        ),
      ],
      child: BlocProvider<AuthBloc>(
        create: (ctx) => AuthBloc(
          authRepository: ctx.read<AuthRepository>(),
        )..add(const AuthStarted()),
        child: MaterialApp(
          theme: ThemeData(
            appBarTheme: AppBarTheme(
              backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            ),
            useMaterial3: true,
          ),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              if (state is AuthAuthenticated) return const HomePage();
              if (state is AuthUnauthenticated) return const AuthPage();
              return const _SplashScreen();
            },
          ),
        ),
      ),
    );
  }
}

class _SplashScreen extends StatelessWidget {
  const _SplashScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
