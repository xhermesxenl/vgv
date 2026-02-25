import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vgv/features/connectivity/bloc/connectivity_cubit.dart';
import 'package:vgv/features/connectivity/domain/repository/connectivity_repository.dart';

class _MockConnectivityRepository extends Mock
    implements ConnectivityRepository {}

void main() {
  late _MockConnectivityRepository repository;
  late StreamController<bool> controller;

  setUp(() {
    repository = _MockConnectivityRepository();
    controller = StreamController<bool>.broadcast();
    when(
      () => repository.onConnectivityChanged,
    ).thenAnswer((_) => controller.stream);
  });

  tearDown(() async {
    await controller.close();
  });

  group('ConnectivityCubit', () {
    group('initial state', () {
      test('is ConnectivityInitial', () {
        when(() => repository.isConnected()).thenAnswer((_) async => true);

        final cubit = ConnectivityCubit(repository: repository);
        expect(cubit.state, const ConnectivityInitial());
        cubit.close();
      });
    });

    group('_checkInitial', () {
      blocTest<ConnectivityCubit, ConnectivityState>(
        'emits ConnectivityOnline when initially connected',
        setUp: () {
          when(() => repository.isConnected()).thenAnswer((_) async => true);
        },
        build: () => ConnectivityCubit(repository: repository),
        expect: () => [const ConnectivityOnline()],
      );

      blocTest<ConnectivityCubit, ConnectivityState>(
        'emits ConnectivityOffline when initially disconnected',
        setUp: () {
          when(() => repository.isConnected()).thenAnswer((_) async => false);
        },
        build: () => ConnectivityCubit(repository: repository),
        expect: () => [const ConnectivityOffline()],
      );
    });

    group('stream subscription', () {
      blocTest<ConnectivityCubit, ConnectivityState>(
        'emits ConnectivityOnline when stream emits true',
        setUp: () {
          when(() => repository.isConnected()).thenAnswer((_) async => true);
        },
        build: () => ConnectivityCubit(repository: repository),
        act: (cubit) => controller.add(true),
        expect: () => [const ConnectivityOnline()],
      );

      blocTest<ConnectivityCubit, ConnectivityState>(
        'emits ConnectivityOffline when stream emits false',
        setUp: () {
          when(() => repository.isConnected()).thenAnswer((_) async => false);
        },
        build: () => ConnectivityCubit(repository: repository),
        act: (cubit) => controller.add(false),
        expect: () => [const ConnectivityOffline()],
      );

      blocTest<ConnectivityCubit, ConnectivityState>(
        'emits correct states for multiple stream events',
        setUp: () {
          when(() => repository.isConnected()).thenAnswer((_) async => true);
        },
        build: () => ConnectivityCubit(repository: repository),
        act: (cubit) {
          controller
            ..add(false)
            ..add(true);
        },
        expect: () => [
          const ConnectivityOnline(),
          const ConnectivityOffline(),
          const ConnectivityOnline(),
        ],
      );
    });

    group('ConnectivityState equality', () {
      test('ConnectivityInitial supports equality', () {
        expect(const ConnectivityInitial(), const ConnectivityInitial());
      });

      test('ConnectivityOnline supports equality', () {
        expect(const ConnectivityOnline(), const ConnectivityOnline());
      });

      test('ConnectivityOffline supports equality', () {
        expect(const ConnectivityOffline(), const ConnectivityOffline());
      });
    });
  });
}
