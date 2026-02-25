import 'package:local_storage_client/local_storage_client.dart';
import 'package:vgv/features/local_storage/domain/repository/secure_storage_repository.dart';

/// [SecureStorageRepository] implementation backed by [SecureStorageClient].
class SecureStorageRepositoryImpl implements SecureStorageRepository {
  const SecureStorageRepositoryImpl({required SecureStorageClient client})
    : _client = client;

  final SecureStorageClient _client;

  @override
  Future<String?> read({required String key}) => _client.read(key: key);

  @override
  Future<void> write({required String key, required String value}) =>
      _client.write(key: key, value: value);

  @override
  Future<void> delete({required String key}) => _client.delete(key: key);

  @override
  Future<void> deleteAll() => _client.deleteAll();

  @override
  Future<bool> containsKey({required String key}) =>
      _client.containsKey(key: key);
}
