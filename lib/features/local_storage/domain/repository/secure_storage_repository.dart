/// Abstract interface for reading and writing sensitive encrypted data.
abstract class SecureStorageRepository {
  Future<String?> read({required String key});
  Future<void> write({required String key, required String value});
  Future<void> delete({required String key});
  Future<void> deleteAll();
  Future<bool> containsKey({required String key});
}
