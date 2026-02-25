import 'package:connectivity_client/connectivity_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:local_storage_client/local_storage_client.dart';
import 'package:vgv/app/router/app_router.dart';
import 'package:vgv/auth/auth.dart';
import 'package:vgv/features/connectivity/bloc/connectivity_cubit.dart';
import 'package:vgv/features/connectivity/data/repository/connectivity_repository_impl.dart';
import 'package:vgv/features/connectivity/domain/repository/connectivity_repository.dart';
import 'package:vgv/features/connectivity/view/connectivity_banner.dart';
import 'package:vgv/features/error_handler/bloc/error_handler_cubit.dart';
import 'package:vgv/features/error_handler/view/error_listener.dart';
import 'package:vgv/features/local_storage/bloc/preferences_cubit.dart';
import 'package:vgv/features/local_storage/data/repository/preferences_repository_impl.dart';
import 'package:vgv/features/local_storage/data/repository/secure_storage_repository_impl.dart';
import 'package:vgv/features/local_storage/domain/repository/preferences_repository.dart';
import 'package:vgv/features/local_storage/domain/repository/secure_storage_repository.dart';
import 'package:vgv/features/splash_onboarding/bloc/onboarding_cubit.dart';
import 'package:vgv/features/splash_onboarding/data/repository/onboarding_repository_impl.dart';
import 'package:vgv/features/splash_onboarding/domain/repository/onboarding_repository.dart';
import 'package:vgv/l10n/l10n.dart';
import 'package:vgv/users/repository/user_repository.dart';

class App extends StatefulWidget {
  const App({
    required SecureStorageClient secureStorageClient,
    required PreferencesClient preferencesClient,
    required ConnectivityClient connectivityClient,
    super.key,
    UserRepository? userRepository,
  })  : _secureStorageClient = secureStorageClient,
        _preferencesClient = preferencesClient,
        _connectivityClient = connectivityClient,
        _userRepository = userRepository;

  final SecureStorageClient _secureStorageClient;
  final PreferencesClient _preferencesClient;
  final ConnectivityClient _connectivityClient;
  final UserRepository? _userRepository;

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final _authRepository = AuthRepository();
  late final AuthBloc _authBloc;
  late final OnboardingCubit _onboardingCubit;
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _authBloc = AuthBloc(authRepository: _authRepository)
      ..add(const AuthStarted());
    _onboardingCubit = OnboardingCubit(
      onboardingRepository: OnboardingRepositoryImpl(
        preferencesRepository: PreferencesRepositoryImpl(
          client: widget._preferencesClient,
        ),
      ),
    )..checkOnboarding();
    _router = createRouter(_authBloc, _onboardingCubit);
  }

  @override
  void dispose() {
    _authBloc.close();
    _onboardingCubit.close();
    _router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthRepository>.value(value: _authRepository),
        RepositoryProvider<UserRepository>(
          create: (_) => widget._userRepository ?? UserRepository(),
        ),
        RepositoryProvider<SecureStorageRepository>(
          create: (_) => SecureStorageRepositoryImpl(
            client: widget._secureStorageClient,
          ),
        ),
        RepositoryProvider<PreferencesRepository>(
          create: (_) => PreferencesRepositoryImpl(
            client: widget._preferencesClient,
          ),
        ),
        RepositoryProvider<OnboardingRepository>(
          create: (_) => OnboardingRepositoryImpl(
            preferencesRepository: PreferencesRepositoryImpl(
              client: widget._preferencesClient,
            ),
          ),
        ),
        RepositoryProvider<ConnectivityRepository>(
          create: (_) => ConnectivityRepositoryImpl(
            client: widget._connectivityClient,
          ),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>.value(value: _authBloc),
          BlocProvider<PreferencesCubit>(
            create: (context) => PreferencesCubit(
              preferencesRepository:
                  context.read<PreferencesRepository>(),
            )..loadPreferences(),
          ),
          BlocProvider<ErrorHandlerCubit>(
            create: (_) => ErrorHandlerCubit(),
          ),
          BlocProvider<OnboardingCubit>.value(value: _onboardingCubit),
          BlocProvider<ConnectivityCubit>(
            create: (context) => ConnectivityCubit(
              repository: context.read<ConnectivityRepository>(),
            ),
          ),
        ],
        child: ConnectivityBanner(
          child: ErrorListener(
            child: MaterialApp.router(
              routerConfig: _router,
              theme: ThemeData(
                colorSchemeSeed: Colors.deepPurple,
                useMaterial3: true,
              ),
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
            ),
          ),
        ),
      ),
    );
  }
}
