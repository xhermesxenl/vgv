import 'dart:async';

import 'package:connectivity_client/connectivity_client.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockConnectivity extends Mock implements Connectivity {}

void main() {
  late _MockConnectivity mockConnectivity;
  late ConnectivityClient client;

  setUp(() {
    mockConnectivity = _MockConnectivity();
    client = ConnectivityClient(connectivity: mockConnectivity);
  });

  group('ConnectivityClient', () {
    group('isConnected', () {
      test('returns true when connected via wifi', () async {
        when(() => mockConnectivity.checkConnectivity())
            .thenAnswer((_) async => [ConnectivityResult.wifi]);

        expect(await client.isConnected(), isTrue);
      });

      test('returns true when connected via mobile', () async {
        when(() => mockConnectivity.checkConnectivity())
            .thenAnswer((_) async => [ConnectivityResult.mobile]);

        expect(await client.isConnected(), isTrue);
      });

      test('returns false when none', () async {
        when(() => mockConnectivity.checkConnectivity())
            .thenAnswer((_) async => [ConnectivityResult.none]);

        expect(await client.isConnected(), isFalse);
      });
    });

    group('onConnectivityChanged', () {
      test('emits true when wifi result received', () async {
        final controller =
            StreamController<List<ConnectivityResult>>();
        when(() => mockConnectivity.onConnectivityChanged)
            .thenAnswer((_) => controller.stream);

        final stream = client.onConnectivityChanged;
        final future = expectLater(stream, emitsInOrder([true, false]));

        controller
          ..add([ConnectivityResult.wifi])
          ..add([ConnectivityResult.none]);

        await future;
        await controller.close();
      });

      test('emits false when none result received', () async {
        final controller =
            StreamController<List<ConnectivityResult>>();
        when(() => mockConnectivity.onConnectivityChanged)
            .thenAnswer((_) => controller.stream);

        final stream = client.onConnectivityChanged;
        final future = expectLater(stream, emits(false));

        controller.add([ConnectivityResult.none]);

        await future;
        await controller.close();
      });
    });
  });
}
