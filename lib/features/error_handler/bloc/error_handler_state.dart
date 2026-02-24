part of 'error_handler_cubit.dart';

/// State emitted by [ErrorHandlerCubit].
///
/// [error] is `null` when no error is active (idle state).
class ErrorHandlerState extends Equatable {
  const ErrorHandlerState({this.error});

  /// The active error to display, or `null` if there is none.
  final AppError? error;

  /// Whether an error is currently active.
  bool get hasError => error != null;

  @override
  List<Object?> get props => [error];
}
