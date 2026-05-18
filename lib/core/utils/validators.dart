// lib/core/utils/validators.dart
class Validators {
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  static String? validateTitle(String? value) {
    return validateRequired(value, 'Title');
  }

  static String? validateOrganization(String? value) {
    return validateRequired(value, 'Organization');
  }

  static String? validateDescription(String? value) {
    return validateRequired(value, 'Description');
  }

  static String? validateLocation(String? value) {
    return validateRequired(value, 'Location');
  }

  static String? validateVolunteers(String? value) {
    if (value == null || value.isEmpty) {
      return 'Number of volunteers is required';
    }
    final number = int.tryParse(value);
    if (number == null || number < 0) {
      return 'Please enter a valid positive number';
    }
    return null;
  }
}