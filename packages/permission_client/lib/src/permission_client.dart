import 'package:permission_handler/permission_handler.dart';

/// Low-level wrapper around the permission_handler plugin.
///
/// Re-exports [Permission] and [PermissionStatus] via the package barrel so
/// that callers only need to import
/// `package:permission_client/permission_client.dart`.
class PermissionClient {
  /// Creates a [PermissionClient].
  ///
  /// [requestPermission] and [checkPermission] are injectable for testing.
  const PermissionClient({
    Future<PermissionStatus> Function(Permission)? requestPermission,
    Future<PermissionStatus> Function(Permission)? checkPermission,
    Future<bool> Function()? openAppSettings,
  })  : _requestPermission = requestPermission ?? _defaultRequest,
        _checkPermission = checkPermission ?? _defaultCheck,
        _openAppSettings = openAppSettings ?? openAppSettings_;

  final Future<PermissionStatus> Function(Permission) _requestPermission;
  final Future<PermissionStatus> Function(Permission) _checkPermission;
  final Future<bool> Function() _openAppSettings;

  static Future<PermissionStatus> _defaultRequest(Permission p) => p.request();
  static Future<PermissionStatus> _defaultCheck(Permission p) => p.status;
  static Future<bool> openAppSettings_() => openAppSettings();

  /// Returns the current [PermissionStatus] for [permission] without prompting.
  Future<PermissionStatus> check(Permission permission) =>
      _checkPermission(permission);

  /// Requests [permission] from the user.
  ///
  /// Returns the resulting [PermissionStatus].
  Future<PermissionStatus> request(Permission permission) =>
      _requestPermission(permission);

  /// Opens the app settings page so the user can change permissions manually.
  ///
  /// Returns `true` if the settings page was opened successfully.
  Future<bool> openSettings() => _openAppSettings();
}
