/// A utility class that provides validation methods for common data types.
///
/// This class contains static methods for validating various data formats
/// such as UUIDs and URLs. It can be used throughout the application
/// wherever data validation is needed.
///
/// Example:
/// ```dart
/// final validators = Validators();
/// if (validators.isValidUuid('123e4567-e89b-12d3-a456-426614174000')) {
///   // UUID is valid
/// }
/// ```
class Validators {
  /// Creates a new instance of [Validators].
  const Validators();

  /// Validates if the given string is a valid UUID v4.
  ///
  /// This method checks if the string matches the UUID v4 format:
  /// 8 hexadecimal digits, followed by three groups of 4 hexadecimal digits,
  /// followed by 12 hexadecimal digits, with hyphens between each group.
  ///
  /// Returns `true` if the string is a valid UUID, `false` otherwise.
  ///
  /// Example:
  /// ```dart
  /// final isValid = validators.isValidUuid('123e4567-e89b-12d3-a456-426614174000');
  /// ```
  bool isValidUuid(String uuid) {
    final uuidRegex = RegExp(
      r'^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$',
      caseSensitive: false,
    );
    return uuidRegex.hasMatch(uuid);
  }

  /// Validates if the given string is a valid URL.
  ///
  /// This method checks if the string can be parsed as a URI and contains
  /// both a scheme (e.g., 'http', 'https') and an authority (e.g., domain).
  ///
  /// Returns `true` if the string is a valid URL, `false` otherwise.
  ///
  /// Example:
  /// ```dart
  /// final isValid = validators.isValidUrl('https://example.com');
  /// ```
  bool isValidUrl(String url) {
    try {
      final uri = Uri.parse(url);
      return uri.hasScheme && uri.hasAuthority;
    } catch (_) {
      return false;
    }
  }
}
