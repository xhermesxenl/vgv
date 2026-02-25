import 'package:shared_preferences/shared_preferences.dart';

/// Client for reading and writing non-sensitive user preferences.
///
/// Backed by [SharedPreferences]. Values are stored unencrypted.
/// Use `SecureStorageClient` for sensitive data.
class PreferencesClient {
  /// Creates a [PreferencesClient].
  ///
  /// Requires a [SharedPreferences] instance.
  /// Obtain it via [PreferencesClient.create] in production code.
  const PreferencesClient({required SharedPreferences preferences})
      : _preferences = preferences;

  /// Factory constructor that initialises [SharedPreferences] internally.
  static Future<PreferencesClient> create() async {
    final preferences = await SharedPreferences.getInstance();
    return PreferencesClient(preferences: preferences);
  }

  final SharedPreferences _preferences;

  /// Reads a [String] value by [key]. Returns `null` if absent.
  String? getString({required String key}) => _preferences.getString(key);

  /// Writes a [String] [value] for [key].
  Future<void> setString({required String key, required String value}) =>
      _preferences.setString(key, value);

  /// Reads a [bool] value by [key]. Returns `null` if absent.
  bool? getBool({required String key}) => _preferences.getBool(key);

  /// Writes a [bool] [value] for [key].
  Future<void> setBool({required String key, required bool value}) =>
      _preferences.setBool(key, value);

  /// Reads an [int] value by [key]. Returns `null` if absent.
  int? getInt({required String key}) => _preferences.getInt(key);

  /// Writes an [int] [value] for [key].
  Future<void> setInt({required String key, required int value}) =>
      _preferences.setInt(key, value);

  /// Removes the entry for [key].
  Future<void> remove({required String key}) => _preferences.remove(key);

  /// Returns `true` if [key] exists.
  bool containsKey({required String key}) => _preferences.containsKey(key);
}
