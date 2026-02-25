import 'package:connectivity_client/connectivity_client.dart';
import 'package:vgv/features/connectivity/domain/repository/connectivity_repository.dart';

class ConnectivityRepositoryImpl implements ConnectivityRepository {
  const ConnectivityRepositoryImpl({required ConnectivityClient client})
      : _client = client;

  final ConnectivityClient _client;

  @override
  Stream<bool> get onConnectivityChanged => _client.onConnectivityChanged;

  @override
  Future<bool> isConnected() => _client.isConnected();
}
