/// Interface for validation services
///
/// This interface defines validation methods for common data types.
/// Implementations can provide different validation strategies.
abstract class ValidationService {
  /// Validates if a string is a valid UUID
  ///
  /// Returns true if the string matches the UUID format (8-4-4-4-12 hex digits)
  bool isValidUuid(String uuid);

  /// Validates if a string is a valid URL
  ///
  /// Returns true if the string can be parsed as a URI and has both
  /// a scheme and an authority
  bool isValidUrl(String url);
}

/// Default implementation of validation services
///
/// This class provides validation methods for common data types.
/// It can be injected wherever validation is needed.
class Validators implements ValidationService {
  /// Creates a new instance of [Validators]
  const Validators();

  @override
  bool isValidUuid(String uuid) {
    final uuidRegex = RegExp(
      r'^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$',
      caseSensitive: false,
    );
    return uuidRegex.hasMatch(uuid);
  }

  @override
  bool isValidUrl(String url) {
    try {
      final uri = Uri.parse(url);
      return uri.hasScheme && uri.hasAuthority;
    } catch (_) {
      return false;
    }
  }
}
