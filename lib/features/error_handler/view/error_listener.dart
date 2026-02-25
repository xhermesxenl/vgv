import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vgv/features/error_handler/bloc/error_handler_cubit.dart';
import 'package:vgv/features/error_handler/domain/model/app_error.dart';

/// Wraps [child] and reacts to [ErrorHandlerCubit] state changes.
///
/// - [ErrorSeverity.warning] : shows a non-blocking [SnackBar].
/// - [ErrorSeverity.critical] : shows a blocking [AlertDialog] with an OK
///   button that the user must dismiss.
///
/// After displaying the error, [ErrorHandlerCubit.clear] is called so the
/// same error is never shown twice.
///
/// Place this widget high in the tree, typically wrapping the
/// [MaterialApp.router] body, so it can access the [ScaffoldMessenger].
class ErrorListener extends StatelessWidget {
  const ErrorListener({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocListener<ErrorHandlerCubit, ErrorHandlerState>(
      listenWhen: (previous, current) =>
          current.hasError && previous.error != current.error,
      listener: _onError,
      child: child,
    );
  }

  void _onError(BuildContext context, ErrorHandlerState state) {
    final appError = state.error;
    if (appError == null) return;

    // Always clear immediately so a re-emit of the same Failure still
    // triggers the listener on the next report() call.
    context.read<ErrorHandlerCubit>().clear();

    switch (appError.severity) {
      case ErrorSeverity.warning:
        _showSnackBar(context, appError.userMessage);
      case ErrorSeverity.critical:
        _showDialog(context, appError.userMessage);
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
  }

  void _showDialog(BuildContext context, String message) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
