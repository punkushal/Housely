class FormValidators {
  // AREA (sq ft)
  static String? area(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Area is required';
    }

    final area = double.tryParse(value);
    if (area == null || area <= 0) {
      return 'Enter a valid area';
    }
    return null;
  }

  // BUILD YEAR
  static String? buildYear(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Build year is required';
    }

    if (!RegExp(r'^\d{4}$').hasMatch(value)) {
      return 'Enter a valid year';
    }

    final year = int.parse(value);
    final currentYear = DateTime.now().year;

    if (year < 1900 || year > currentYear) {
      return 'Must be between 1900 and $currentYear';
    }

    return null;
  }

  // PROPERTY TITLE
  static String? title(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Title is required';
    }

    if (value.trim().length < 5) {
      return 'Must be at least 5 characters';
    }

    return null;
  }

  // DESCRIPTION
  static String? description(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Description is required';
    }

    if (value.trim().length < 20) {
      return 'Must be at least 20 characters';
    }

    return null;
  }

  // PRICE
  static String? price(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Price is required';
    }

    final price = double.tryParse(value);
    if (price == null || price <= 0) {
      return 'Enter a valid price';
    }

    return null;
  }

  // BEDROOMS / BATHROOMS
  static String? rooms(String? value, {required String label}) {
    if (value == null || value.trim().isEmpty) {
      return '$label is required';
    }

    final count = int.tryParse(value);
    if (count == null || count < 0 || count > 20) {
      return 'Enter a valid $label count';
    }

    return null;
  }

  // Email Validator
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }

    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }

    return null;
  }

  // Password Validator
  static String? validatePassword(
    String? value, {
    int minLength = 8,
    bool requireUppercase = true,
    bool requireLowercase = true,
    bool requireDigit = true,
    bool requireSpecialChar = true,
  }) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }

    if (value.length < minLength) {
      return 'Must be at least $minLength characters long';
    }

    if (requireUppercase && !value.contains(RegExp(r'[A-Z]'))) {
      return 'Must contain at least one uppercase letter';
    }

    if (requireLowercase && !value.contains(RegExp(r'[a-z]'))) {
      return 'Must contain at least one lowercase letter';
    }

    if (requireDigit && !value.contains(RegExp(r'[0-9]'))) {
      return 'Must contain at least one digit';
    }

    if (requireSpecialChar &&
        !value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return 'Must contain at least one special character';
    }

    return null;
  }

  // Confirm Password Validator
  static String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }

    if (value != password) {
      return 'Passwords do not match';
    }

    return null;
  }

  // Username Validator
  static String? validateUsername(
    String? value, {
    int minLength = 3,
    int maxLength = 20,
    bool allowSpaces = false,
  }) {
    if (value == null || value.isEmpty) {
      return 'Username is required';
    }

    if (value.length < minLength) {
      return 'Must be at least $minLength characters long';
    }

    if (value.length > maxLength) {
      return 'Username must not exceed $maxLength characters';
    }

    if (!allowSpaces && value.contains(' ')) {
      return 'Username cannot contain spaces';
    }

    final usernameRegex = RegExp(r'^[a-zA-Z0-9_]+$');
    if (!usernameRegex.hasMatch(value)) {
      return 'Must Only contain letters, numbers, and underscores';
    }

    return null;
  }

  // full name validator
  static String? validateFullName(String? value) {
    //  Check if empty
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your full name';
    }

    //  Check for at least two words (First Name + Last Name)
    // Logic: distinct words separated by a space, each at least 2 chars long.
    final nameRegExp = RegExp(r"^[a-zA-Z]{2,}(\s+[a-zA-Z]{2,})+$");

    if (!nameRegExp.hasMatch(value.trim())) {
      return 'Please enter a valid full name (e.g. Kushal Pun)';
    }

    return null;
  }

  // Phone Number Validator
  static String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }

    final phoneRegex = RegExp(r'^\+?[\d\s-]{10,}$');
    if (!phoneRegex.hasMatch(value)) {
      return 'Please enter a valid phone number';
    }

    return null;
  }
}
