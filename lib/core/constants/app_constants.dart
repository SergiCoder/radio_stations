/// Application constants
class AppConstants {
  AppConstants._();

  /// Maximum length for dropdown items before truncation
  static const int maxDropdownItemLength = 20;

  /// Default debounce duration for text inputs in milliseconds
  static const int defaultDebounceDuration = 500;

  /// Default throttle duration in milliseconds
  static const int defaultThrottleDuration = 2000;

  /// Throttle duration for next/previous navigation in milliseconds
  static const int navigationThrottleMs = 1000;

  /// Throttle duration for playback toggle in milliseconds
  static const int playbackThrottleMs = 1000;

  /// Throttle duration for volume slider changes in milliseconds
  static const int volumeChangeThrottleMs = 80;

  /// Minimum length for search terms
  static const int minSearchTermLength = 2;
}
