import 'package:vgv/features/permissions/domain/models/app_permission.dart';
import 'package:vgv/features/permissions/domain/models/app_permission_status.dart';

/// Abstract interface for permission operations.
///
/// Implementations translate between [AppPermission]/[AppPermissionStatus]
/// and the underlying platform plugin types.
abstract class PermissionRepository {
  /// Returns the current [AppPermissionStatus] for [permission]
  /// without prompting the user.
  Future<AppPermissionStatus> check(AppPermission permission);

  /// Requests [permission] from the user.
  ///
  /// Returns the resulting [AppPermissionStatus].
  Future<AppPermissionStatus> request(AppPermission permission);

  /// Opens the app's system settings page.
  ///
  /// Used when a permission is [AppPermissionStatus.permanentlyDenied].
  /// Returns `true` if the settings page was opened successfully.
  Future<bool> openSettings();
}
