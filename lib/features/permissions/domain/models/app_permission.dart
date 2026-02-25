/// The set of permissions managed by the boilerplate.
///
/// Add entries here when a new permission is required by the app.
/// Each entry maps to a platform permission in the repository implementation.
enum AppPermission {
  /// Device camera.
  camera,

  /// Photo library / media images (READ_MEDIA_IMAGES on Android 13+,
  /// READ_EXTERNAL_STORAGE on older versions).
  photos,

  /// Push notification delivery.
  notifications,
}
