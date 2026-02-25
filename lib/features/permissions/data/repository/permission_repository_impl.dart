import 'package:permission_client/permission_client.dart';
import 'package:vgv/features/permissions/domain/models/app_permission.dart';
import 'package:vgv/features/permissions/domain/models/app_permission_status.dart';
import 'package:vgv/features/permissions/domain/repository/permission_repository.dart';

/// [PermissionRepository] implementation backed by [PermissionClient].
///
/// Translates between domain types ([AppPermission], [AppPermissionStatus])
/// and plugin types ([Permission], [PermissionStatus]).
class PermissionRepositoryImpl implements PermissionRepository {
  const PermissionRepositoryImpl({required PermissionClient client})
      : _client = client;

  final PermissionClient _client;

  @override
  Future<AppPermissionStatus> check(AppPermission permission) async {
    final status = await _client.check(_toPermission(permission));
    return _toAppStatus(status);
  }

  @override
  Future<AppPermissionStatus> request(AppPermission permission) async {
    final status = await _client.request(_toPermission(permission));
    return _toAppStatus(status);
  }

  @override
  Future<bool> openSettings() => _client.openSettings();

  // ---------------------------------------------------------------------------
  // Mappers
  // ---------------------------------------------------------------------------

  static Permission _toPermission(AppPermission permission) {
    return switch (permission) {
      AppPermission.camera => Permission.camera,
      AppPermission.photos => Permission.photos,
      AppPermission.notifications => Permission.notification,
    };
  }

  static AppPermissionStatus _toAppStatus(PermissionStatus status) {
    return switch (status) {
      PermissionStatus.granted => AppPermissionStatus.granted,
      PermissionStatus.permanentlyDenied ||
      PermissionStatus.restricted =>
        AppPermissionStatus.permanentlyDenied,
      _ => AppPermissionStatus.denied,
    };
  }
}
