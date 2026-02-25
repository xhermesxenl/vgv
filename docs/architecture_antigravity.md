# Architecture Antigravity

This document is automatically generated. It represents the current architecture of the application, focusing on the integration of key components.

```mermaid
classDiagram
  class App
  class AuthBloc
  class AuthPage
  class AuthRepository
  class ConnectivityCubit
  class ConnectivityRepository
  class ErrorHandlerCubit
  class HomePage
  class LoginCubit
  class OnboardingCubit
  class OnboardingPage
  class OnboardingRepository
  class PermissionCubit
  class PermissionRepository
  class PreferencesCubit
  class PreferencesRepository
  class SecureStorageRepository
  class UserBloc
  class UserFormPage
  class UserRepository
  class UsersPage
  class _OnboardingStepPage
  class _SplashPage
  App --> AuthBloc
  App --> AuthRepository
  App --> ConnectivityCubit
  App --> ConnectivityRepository
  App --> ErrorHandlerCubit
  App --> OnboardingCubit
  App --> OnboardingRepository
  App --> PreferencesCubit
  App --> PreferencesRepository
  App --> SecureStorageRepository
  App --> UserRepository
  AuthBloc --> AuthRepository
  AuthPage --> AuthRepository
  AuthPage --> LoginCubit
  ConnectivityCubit --> ConnectivityRepository
  HomePage --> AuthBloc
  HomePage --> UsersPage
  LoginCubit --> AuthRepository
  OnboardingCubit --> OnboardingRepository
  OnboardingPage --> App
  PermissionCubit --> PermissionRepository
  PreferencesCubit --> PreferencesRepository
  UserBloc --> UserRepository
  UserFormPage --> UserRepository
  UsersPage --> UserBloc
  UsersPage --> UserFormPage
  UsersPage --> UserRepository
  _OnboardingStepPage --> OnboardingCubit
  _SplashPage --> AuthBloc
  _SplashPage --> AuthPage
  _SplashPage --> HomePage
  _SplashPage --> OnboardingCubit
  _SplashPage --> OnboardingPage
```
