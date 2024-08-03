class AuthenticationValidator {
  AuthenticationValidator._();

  static String? emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

    if (!emailRegex.hasMatch(value)) {
      return 'Enter a valid email address';
    }

    return null;
  }

  static String? passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }

    if (value.length < 8) {
      return 'Password must be at least 8 characters long';
    }

    final hasUppercase = RegExp(r'[A-Z]').hasMatch(value);
    final hasLowercase = RegExp(r'[a-z]').hasMatch(value);
    final hasDigits = RegExp(r'\d').hasMatch(value);
    final hasSpecialCharacters = RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value);

    if (!hasUppercase) {
      return 'Password must contain at least one uppercase letter';
    }

    if (!hasLowercase) {
      return 'Password must contain at least one lowercase letter';
    }

    if (!hasDigits) {
      return 'Password must contain at least one number';
    }

    if (!hasSpecialCharacters) {
      return 'Password must contain at least one special character';
    }

    return null;
  }

  static String? fullNameValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name is required';
    }

    return null;
  }

  static String? updateFullNameValidator(String? value, {String? originalName}) {
    if (value == null || value.isEmpty) {
      return 'Name is required';
    }

    // Check if the new name is different from the original name
    if (originalName != null && value.trim().toLowerCase() == originalName.trim().toLowerCase()) {
      return ' ';
    }

    return null;
  }
}