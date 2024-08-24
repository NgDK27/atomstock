String extractErrorResponse(Map<String, dynamic> errorData, String errorIdentifier) {
  final errorString = errorData['error'] as String?;
  if (errorString != null && errorString.contains('$errorIdentifier:')) {
    final parts = errorString.split('$errorIdentifier:');
    if (parts.length > 1) {
      String message = parts[1].trim();
      // Remove the final period if it exists
      if (message.endsWith('.')) {
        message = message.substring(0, message.length - 1);
      }
      return message;
    }
  }
  return 'An error occurred';
}

String extractUserFriendlyErrorMessage(Map<String, dynamic> errorData) {
  final errorString = errorData['error'] as String?;
  if (errorString == null) return 'An unknown error occurred';

  // List of known error types
  final knownErrors = [
    'InvalidPasswordException',
    'UsernameExistsException',
    'InvalidParameterException',
  ];

  for (var errorType in knownErrors) {
    if (errorString.contains(errorType)) {
      final split = errorString.split('$errorType:');
      if (split.length > 1) {
        var message = split.last.trim();

        // Handle specific cases
        if (message.startsWith('Password did not conform with policy:')) {
          message = message.split('Password did not conform with policy:').last.trim();
        }

        // Remove the final period if it exists
        if (message.endsWith('.')) {
          message = message.substring(0, message.length - 1);
        }

        return message;
      }
    }
  }

  return 'An unexpected error occurred';
}
