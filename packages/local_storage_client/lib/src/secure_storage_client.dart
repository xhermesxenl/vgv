import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Client for reading and writing sensitive data using encrypted storage.
///
/// Backed by [FlutterSecureStorage] which uses Android Keystore on Android.
class SecureStorageClient {
  /// Creates a [SecureStorageClient].
  ///
  /// Optionally inject a [FlutterSecureStorage] for testing.
  const SecureStorageClient({
    FlutterSecureStorage? storage,
  }) : _storage = storage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _storage;

  /// Reads a value by [key]. Returns `null` if absent.
  Future<String?> read({required String key}) => _storage.read(key: key);

  /// Writes [value] for [key].
  Future<void> write({required String key, required String value}) =>
      _storage.write(key: key, value: value);

  /// Deletes the entry for [key].
  Future<void> delete({required String key}) => _storage.delete(key: key);

  /// Deletes all entries.
  Future<void> deleteAll() => _storage.deleteAll();

  /// Returns `true` if [key] exists.
  Future<bool> containsKey({required String key}) =>
      _storage.containsKey(key: key);
}
