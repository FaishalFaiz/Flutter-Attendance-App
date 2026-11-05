/// Core exceptions for the Attendance App

class AppException implements Exception {
  final String message;
  final String? code;
  final bool isRetryable;

  const AppException({
    required this.message,
    this.code,
    this.isRetryable = false,
  });

  @override
  String toString() => '$runtimeType: $message';
}

/// Thrown when authentication fails (invalid credentials, etc.)
class AuthException extends AppException {
  const AuthException({
    required super.message,
    super.code,
    super.isRetryable = false,
  });
}

/// Thrown when a user is not authenticated
class UnauthenticatedException extends AppException {
  const UnauthenticatedException({
    super.message = 'User not authenticated. Please log in.',
    super.code = 'UNAUTHENTICATED',
  }) : super(isRetryable: false);
}

/// Thrown when a user doesn't have permission for an action
class UnauthorizedException extends AppException {
  const UnauthorizedException({
    super.message = 'You do not have permission to perform this action.',
    super.code = 'UNAUTHORIZED',
  }) : super(isRetryable: false);
}

/// Thrown when a resource is not found
class NotFoundException extends AppException {
  const NotFoundException({
    required super.message,
    super.code = 'NOT_FOUND',
  }) : super(isRetryable: false);
}

/// Thrown when there's a network connectivity issue
class NetworkException extends AppException {
  const NetworkException({
    super.message = 'No internet connection. Please check your network.',
    super.code = 'NETWORK_ERROR',
  }) : super(isRetryable: true);
}

/// Thrown when Firestore operation fails
class FirestoreException extends AppException {
  const FirestoreException({
    required super.message,
    super.code,
    super.isRetryable = true,
  });
}

/// Thrown when Firebase Storage operation fails
class StorageException extends AppException {
  const StorageException({
    required super.message,
    super.code,
    super.isRetryable = true,
  });
}

/// Thrown when face verification fails
class FaceVerificationException extends AppException {
  const FaceVerificationException({
    required super.message,
    super.code,
    super.isRetryable = false,
  });
}

/// Thrown when Hive local database operation fails
class LocalStorageException extends AppException {
  const LocalStorageException({
    required super.message,
    super.code,
    super.isRetryable = false,
  });
}

/// Thrown when validation fails
class ValidationException extends AppException {
  const ValidationException({
    required super.message,
    super.code = 'VALIDATION_ERROR',
  }) : super(isRetryable: false);
}

/// Thrown when an organization is not found or user is not a member
class OrganizationException extends AppException {
  const OrganizationException({
    required super.message,
    super.code = 'ORGANIZATION_ERROR',
  }) : super(isRetryable: false);
}