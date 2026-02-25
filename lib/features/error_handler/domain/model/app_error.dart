import 'package:equatable/equatable.dart';
import 'package:vgv/core/errors/errors.dart';

/// Severity level that drives the UI presentation of an error.
///
/// - [warning] : non-blocking, displayed as a SnackBar.
/// - [critical] : blocking, displayed as a Dialog requiring user action.
enum ErrorSeverity { warning, critical }

/// Wraps a [Failure] with the UI metadata needed by the error listener widget.
///
/// Immutable and comparable via [Equatable].
class AppError extends Equatable {
  const AppError({
    required this.failure,
    this.severity = ErrorSeverity.warning,
  });

  /// The domain failure that triggered this error.
  final Failure failure;

  /// How the error should be presented to the user.
  final ErrorSeverity severity;

  /// Localizable message forwarded to the UI layer.
  String get userMessage => failure.message;

  @override
  List<Object?> get props => [failure, severity];
}
