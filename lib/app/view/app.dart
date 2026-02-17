import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vgv/home/home.dart';
import 'package:vgv/l10n/l10n.dart';
import 'package:vgv/users/repository/user_repository.dart';

class App extends StatelessWidget {
  const App({super.key, UserRepository? userRepository})
      : _userRepository = userRepository;

  final UserRepository? _userRepository;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<UserRepository>(
      create: (_) => _userRepository ?? UserRepository(),
      child: MaterialApp(
        theme: ThemeData(
          appBarTheme: AppBarTheme(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          ),
          useMaterial3: true,
        ),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const HomePage(),
      ),
    );
  }
}
