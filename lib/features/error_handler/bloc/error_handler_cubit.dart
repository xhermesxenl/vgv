import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vgv/core/errors/errors.dart';
import 'package:vgv/features/error_handler/domain/model/app_error.dart';

part 'error_handler_state.dart';

/// Cubit that exposes a single active [AppError] to the UI layer.
///
/// Call [report] to push a new error and [clear] to dismiss it.
/// The cubit holds no business logic — it is a pure notification bus.
class ErrorHandlerCubit extends Cubit<ErrorHandlerState> {
  ErrorHandlerCubit() : super(const ErrorHandlerState());

  /// Publishes [failure] wrapped in an [AppError] with [severity].
  ///
  /// Defaults to [ErrorSeverity.warning] (non-blocking SnackBar).
  /// Pass [ErrorSeverity.critical] to trigger a blocking Dialog.
  void report(
    Failure failure, {
    ErrorSeverity severity = ErrorSeverity.warning,
  }) {
    emit(
      ErrorHandlerState(
        error: AppError(failure: failure, severity: severity),
      ),
    );
  }

  /// Clears the active error, returning to the idle state.
  void clear() => emit(const ErrorHandlerState());
}
