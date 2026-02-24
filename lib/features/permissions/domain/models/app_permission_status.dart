/// Domain-level status for a single permission.
///
/// Maps to the permission_handler plugin's PermissionStatus without leaking
/// the plugin type outside `packages/permission_client`.
enum AppPermissionStatus {
  /// Status not yet checked.
  unknown,

  /// The user has granted the permission.
  granted,

  /// The user has denied the permission (can be asked again).
  denied,

  /// The user has permanently denied the permission.
  /// The app must redirect to system settings to recover.
  permanentlyDenied,
}
