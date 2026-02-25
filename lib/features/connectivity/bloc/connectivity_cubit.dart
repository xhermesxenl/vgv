import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vgv/features/connectivity/domain/repository/connectivity_repository.dart';

part 'connectivity_state.dart';

class ConnectivityCubit extends Cubit<ConnectivityState> {
  ConnectivityCubit({required ConnectivityRepository repository})
      : _repository = repository,
        super(const ConnectivityInitial()) {
    _subscription = _repository.onConnectivityChanged.listen(
      (isConnected) => emit(
        isConnected ? const ConnectivityOnline() : const ConnectivityOffline(),
      ),
    );
    _checkInitial();
  }

  final ConnectivityRepository _repository;
  late final StreamSubscription<bool> _subscription;

  Future<void> _checkInitial() async {
    final isConnected = await _repository.isConnected();
    if (!isClosed) {
      emit(
        isConnected ? const ConnectivityOnline() : const ConnectivityOffline(),
      );
    }
  }

  @override
  Future<void> close() {
    _subscription.cancel();
    return super.close();
  }
}
