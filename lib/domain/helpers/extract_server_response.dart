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
