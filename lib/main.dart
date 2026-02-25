import 'package:connectivity_client/connectivity_client.dart';
import 'package:local_storage_client/local_storage_client.dart';
import 'package:vgv/app/app.dart';
import 'package:vgv/bootstrap.dart';

void main() {
  bootstrap(
    ({
      required SecureStorageClient secureStorageClient,
      required PreferencesClient preferencesClient,
      required ConnectivityClient connectivityClient,
    }) => App(
      secureStorageClient: secureStorageClient,
      preferencesClient: preferencesClient,
      connectivityClient: connectivityClient,
    ),
  );
}
