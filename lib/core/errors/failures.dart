import 'package:equatable/equatable.dart';

/// Base class for all domain failures.
///
/// Implements [Exception] so failures can be thrown and caught idiomatically.
/// Use sealed subclasses to represent specific failure categories.
sealed class Failure extends Equatable implements Exception {
  const Failure({required this.message});

  /// Human-readable description of the failure.
  final String message;

  @override
  List<Object?> get props => [message];
}

/// Failure caused by a network issue (no connection, timeout, DNS error).
final class NetworkFailure extends Failure {
  const NetworkFailure({
    super.message = 'A network error occurred. Please check your connection.',
  });
}

/// Failure returned by the Supabase server (RLS violation, not found,
/// conflict, internal server error, etc.).
final class ServerFailure extends Failure {
  const ServerFailure({
    required super.message,
    this.statusCode,
  });

  /// HTTP status code returned by the server, if available.
  final int? statusCode;

  @override
  List<Object?> get props => [message, statusCode];
}

/// Failure related to authentication (expired session, wrong credentials,
/// unauthorized access, etc.).
final class AuthFailure extends Failure {
  const AuthFailure({
    super.message = 'An authentication error occurred. Please sign in again.',
  });
}

/// Failure caused by a local storage read or write error
/// (secure storage, shared preferences).
final class StorageFailure extends Failure {
  const StorageFailure({
    super.message = 'A storage error occurred. Please try again.',
  });
}

/// Catch-all failure for unexpected or unclassified errors.
final class UnknownFailure extends Failure {
  const UnknownFailure({
    super.message = 'An unexpected error occurred. Please try again.',
  });
}
