import 'dart:async';

import 'package:connectivity_client/connectivity_client.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vgv/features/connectivity/data/repository/connectivity_repository_impl.dart';

class _MockConnectivityClient extends Mock implements ConnectivityClient {}

void main() {
  late _MockConnectivityClient client;
  late ConnectivityRepositoryImpl repository;

  setUp(() {
    client = _MockConnectivityClient();
    repository = ConnectivityRepositoryImpl(client: client);
  });

  group('ConnectivityRepositoryImpl', () {
    test('isConnected delegates to client', () async {
      when(() => client.isConnected()).thenAnswer((_) async => true);

      final result = await repository.isConnected();

      expect(result, isTrue);
      verify(() => client.isConnected()).called(1);
    });

    test('isConnected returns false when client returns false', () async {
      when(() => client.isConnected()).thenAnswer((_) async => false);

      final result = await repository.isConnected();

      expect(result, isFalse);
    });

    test('onConnectivityChanged delegates to client stream', () async {
      final controller = StreamController<bool>();
      when(
        () => client.onConnectivityChanged,
      ).thenAnswer((_) => controller.stream);

      final stream = repository.onConnectivityChanged;
      final future = expectLater(stream, emitsInOrder([true, false]));

      controller
        ..add(true)
        ..add(false);

      await future;
      await controller.close();
    });
  });
}
