import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vgv/features/permissions/domain/models/app_permission.dart';
import 'package:vgv/features/permissions/domain/models/app_permission_status.dart';
import 'package:vgv/features/permissions/domain/repository/permission_repository.dart';

part 'permission_state.dart';

/// Cubit responsible for checking and requesting app permissions.
///
/// Typical usage:
/// 1. Call [checkAll] at startup to populate the current statuses.
/// 2. Call [request] or [requestAll] before accessing a protected resource.
/// 3. Call [openSettings] when a permission is permanently denied.
class PermissionCubit extends Cubit<PermissionState> {
  PermissionCubit({required PermissionRepository repository})
    : _repository = repository,
      super(const PermissionState());

  final PermissionRepository _repository;

  /// Checks the current status of every [AppPermission] without prompting.
  Future<void> checkAll() async {
    final entries = await Future.wait(
      AppPermission.values.map(
        (p) async => MapEntry(p, await _repository.check(p)),
      ),
    );
    emit(state.copyWith(statuses: Map.fromEntries(entries)));
  }

  /// Requests a single [permission] from the user and updates state.
  Future<void> request(AppPermission permission) async {
    final status = await _repository.request(permission);
    emit(state.copyWith(statuses: {...state.statuses, permission: status}));
  }

  /// Requests each permission in [permissions] sequentially and updates state.
  Future<void> requestAll(List<AppPermission> permissions) async {
    final statuses = Map<AppPermission, AppPermissionStatus>.from(
      state.statuses,
    );
    for (final permission in permissions) {
      statuses[permission] = await _repository.request(permission);
    }
    emit(state.copyWith(statuses: statuses));
  }

  /// Opens the system app settings page.
  ///
  /// Call this when a permission is [AppPermissionStatus.permanentlyDenied].
  Future<void> openSettings() => _repository.openSettings();
}
