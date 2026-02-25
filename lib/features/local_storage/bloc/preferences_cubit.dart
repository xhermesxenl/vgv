import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vgv/features/local_storage/domain/repository/preferences_repository.dart';

part 'preferences_state.dart';

/// Keys used to persist preferences in [PreferencesRepository].
const _kThemeModeKey = 'themeMode';
const _kLocaleKey = 'locale';

/// Cubit responsible for loading and persisting user preferences.
class PreferencesCubit extends Cubit<PreferencesState> {
  PreferencesCubit({required PreferencesRepository preferencesRepository})
    : _repository = preferencesRepository,
      super(const PreferencesState());

  final PreferencesRepository _repository;

  /// Loads persisted preferences and emits the corresponding state.
  Future<void> loadPreferences() async {
    final themeModeIndex = _repository.getInt(key: _kThemeModeKey);
    final localeCode = _repository.getString(key: _kLocaleKey);

    final themeMode = themeModeIndex != null
        ? ThemeMode.values[themeModeIndex]
        : ThemeMode.system;

    final locale = localeCode != null ? Locale(localeCode) : null;

    emit(PreferencesState(themeMode: themeMode, locale: locale));
  }

  /// Persists [themeMode] and emits the updated state.
  Future<void> setThemeMode(ThemeMode themeMode) async {
    await _repository.setInt(key: _kThemeModeKey, value: themeMode.index);
    emit(state.copyWith(themeMode: themeMode));
  }

  /// Persists [locale] (or clears it when `null`) and emits the updated state.
  Future<void> setLocale(Locale? locale) async {
    if (locale == null) {
      await _repository.remove(key: _kLocaleKey);
      emit(state.copyWith(clearLocale: true));
    } else {
      await _repository.setString(key: _kLocaleKey, value: locale.languageCode);
      emit(state.copyWith(locale: locale));
    }
  }
}
