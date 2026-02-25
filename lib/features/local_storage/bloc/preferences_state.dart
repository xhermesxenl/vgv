part of 'preferences_cubit.dart';

class PreferencesState extends Equatable {
  const PreferencesState({this.themeMode = ThemeMode.system, this.locale});

  final ThemeMode themeMode;
  final Locale? locale;

  @override
  List<Object?> get props => [themeMode, locale];

  PreferencesState copyWith({
    ThemeMode? themeMode,
    Locale? locale,
    bool clearLocale = false,
  }) {
    return PreferencesState(
      themeMode: themeMode ?? this.themeMode,
      locale: clearLocale ? null : locale ?? this.locale,
    );
  }
}
