part of 'permission_cubit.dart';

/// Immutable state holding the [AppPermissionStatus] for every
/// [AppPermission].
///
/// Starts with all permissions as [AppPermissionStatus.unknown].
class PermissionState extends Equatable {
  const PermissionState({
    this.statuses = const {},
  });

  /// Status map — keys are [AppPermission] values.
  final Map<AppPermission, AppPermissionStatus> statuses;

  /// Returns the [AppPermissionStatus] for [permission].
  ///
  /// Defaults to [AppPermissionStatus.unknown] if not yet checked.
  AppPermissionStatus statusOf(AppPermission permission) =>
      statuses[permission] ?? AppPermissionStatus.unknown;

  /// `true` when all [AppPermission] values are [AppPermissionStatus.granted].
  bool get allGranted => AppPermission.values
      .every((p) => statuses[p] == AppPermissionStatus.granted);

  PermissionState copyWith({
    Map<AppPermission, AppPermissionStatus>? statuses,
  }) {
    return PermissionState(
      statuses: statuses ?? this.statuses,
    );
  }

  @override
  List<Object?> get props => [statuses];
}
