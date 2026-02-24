/// Abstract interface for reading and writing non-sensitive user preferences.
abstract class PreferencesRepository {
  String? getString({required String key});
  Future<void> setString({required String key, required String value});
  bool? getBool({required String key});
  Future<void> setBool({required String key, required bool value});
  int? getInt({required String key});
  Future<void> setInt({required String key, required int value});
  Future<void> remove({required String key});
  bool containsKey({required String key});
}
