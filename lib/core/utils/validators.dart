/// Utility class containing common validation methods
class Validators {
  /// Validates if a string is a valid UUID
  ///
  /// Returns true if the string matches the UUID format:
  /// 8-4-4-4-12 hexadecimal digits
  static bool isValidUuid(String uuid) {
    final uuidRegex = RegExp(
      r'^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$',
      caseSensitive: false,
    );
    return uuidRegex.hasMatch(uuid);
  }

  /// Validates if a string is a valid URL
  ///
  /// Returns true if the string can be parsed as a URI and has both
  /// a scheme and an authority
  static bool isValidUrl(String url) {
    try {
      final uri = Uri.parse(url);
      return uri.hasScheme && uri.hasAuthority;
    } catch (_) {
      return false;
    }
  }
}
