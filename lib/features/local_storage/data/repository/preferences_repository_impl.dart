import 'package:local_storage_client/local_storage_client.dart';
import 'package:vgv/features/local_storage/domain/repository/preferences_repository.dart';

/// [PreferencesRepository] implementation backed by [PreferencesClient].
class PreferencesRepositoryImpl implements PreferencesRepository {
  const PreferencesRepositoryImpl({required PreferencesClient client})
      : _client = client;

  final PreferencesClient _client;

  @override
  String? getString({required String key}) => _client.getString(key: key);

  @override
  Future<void> setString({required String key, required String value}) =>
      _client.setString(key: key, value: value);

  @override
  bool? getBool({required String key}) => _client.getBool(key: key);

  @override
  Future<void> setBool({required String key, required bool value}) =>
      _client.setBool(key: key, value: value);

  @override
  int? getInt({required String key}) => _client.getInt(key: key);

  @override
  Future<void> setInt({required String key, required int value}) =>
      _client.setInt(key: key, value: value);

  @override
  Future<void> remove({required String key}) => _client.remove(key: key);

  @override
  bool containsKey({required String key}) => _client.containsKey(key: key);
}
