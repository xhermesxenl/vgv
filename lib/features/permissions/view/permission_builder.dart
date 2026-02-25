import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vgv/features/permissions/bloc/permission_cubit.dart';
import 'package:vgv/features/permissions/domain/models/app_permission.dart';
import 'package:vgv/features/permissions/domain/models/app_permission_status.dart';

/// Builds different UI depending on the current [AppPermissionStatus] of
/// a given [AppPermission].
///
/// Reads [PermissionCubit] from the widget tree. The cubit must be provided
/// by an ancestor [BlocProvider].
///
/// Example:
/// ```dart
/// PermissionBuilder(
///   permission: AppPermission.camera,
///   granted: (_) => const CameraView(),
///   denied: (context, cubit) => ElevatedButton(
///     onPressed: () => cubit.request(AppPermission.camera),
///     child: const Text('Allow camera'),
///   ),
///   permanentlyDenied: (context, cubit) => ElevatedButton(
///     onPressed: cubit.openSettings,
///     child: const Text('Open settings'),
///   ),
/// )
/// ```
class PermissionBuilder extends StatelessWidget {
  const PermissionBuilder({
    required this.permission,
    required this.granted,
    required this.denied,
    required this.permanentlyDenied,
    super.key,
    this.unknown,
  });

  /// The permission to observe.
  final AppPermission permission;

  /// Built when the permission is [AppPermissionStatus.granted].
  final Widget Function(BuildContext context) granted;

  /// Built when the permission is [AppPermissionStatus.denied].
  final Widget Function(BuildContext context, PermissionCubit cubit) denied;

  /// Built when the permission is [AppPermissionStatus.permanentlyDenied].
  final Widget Function(BuildContext context, PermissionCubit cubit)
      permanentlyDenied;

  /// Built while the status is [AppPermissionStatus.unknown].
  ///
  /// Defaults to an empty [SizedBox].
  final Widget Function(BuildContext context)? unknown;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PermissionCubit, PermissionState>(
      builder: (context, state) {
        final cubit = context.read<PermissionCubit>();
        final status = state.statusOf(permission);

        return switch (status) {
          AppPermissionStatus.granted => granted(context),
          AppPermissionStatus.denied => denied(context, cubit),
          AppPermissionStatus.permanentlyDenied =>
            permanentlyDenied(context, cubit),
          AppPermissionStatus.unknown =>
            unknown?.call(context) ?? const SizedBox.shrink(),
        };
      },
    );
  }
}
