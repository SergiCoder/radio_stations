import 'package:flutter/material.dart';

/// Application typography styles
///
/// This class defines the text styles used throughout the application,
/// providing a consistent set of typography for different purposes.
class AppTypography {
  /// Display styles for large headlines
  ///
  /// Used for the largest text elements in the application,
  /// such as hero sections and main headlines.
  static const TextStyle displayLarge = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    letterSpacing: -0.5,
  );

  /// Display style for medium-sized headlines
  ///
  /// Used for prominent but slightly smaller headlines,
  /// such as section headers and feature titles.
  static const TextStyle displayMedium = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    letterSpacing: -0.5,
  );

  /// Display style for smaller headlines
  ///
  /// Used for headlines that need to be prominent
  /// but not as large as the main display styles.
  static const TextStyle displaySmall = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    letterSpacing: -0.5,
  );

  /// Headline style for large section titles
  ///
  /// Used for section headers and important content
  /// that needs to stand out from regular text.
  static const TextStyle headlineLarge = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.25,
  );

  /// Headline style for medium section titles
  ///
  /// Used for subsection headers and content that
  /// needs to be distinct from regular text.
  static const TextStyle headlineMedium = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.25,
  );

  /// Headline style for small section titles
  ///
  /// Used for minor section headers and content that
  /// needs slight emphasis.
  static const TextStyle headlineSmall = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.25,
  );

  /// Title style for large component headers
  ///
  /// Used for component titles and important labels
  /// that need to be clearly visible.
  static const TextStyle titleLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.15,
  );

  /// Title style for medium component headers
  ///
  /// Used for component subtitles and secondary labels
  /// that need to be distinct but not too prominent.
  static const TextStyle titleMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
  );

  /// Title style for small component headers
  ///
  /// Used for minor component labels and tertiary
  /// information that needs slight emphasis.
  static const TextStyle titleSmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
  );

  /// Body style for large text content
  ///
  /// Used for the main body text and primary content
  /// that needs to be easily readable.
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    letterSpacing: 0.5,
  );

  /// Body style for medium text content
  ///
  /// Used for secondary body text and supporting
  /// content that complements the main text.
  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    letterSpacing: 0.25,
  );

  /// Body style for small text content
  ///
  /// Used for tertiary content, captions, and
  /// supplementary information.
  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    letterSpacing: 0.4,
  );

  /// Label style for large form elements
  ///
  /// Used for form field labels and important
  /// interactive element labels.
  static const TextStyle labelLarge = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
  );

  /// Label style for medium form elements
  ///
  /// Used for secondary form labels and less
  /// prominent interactive element labels.
  static const TextStyle labelMedium = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
  );

  /// Label style for small form elements
  ///
  /// Used for tertiary form labels and minor
  /// interactive element labels.
  static const TextStyle labelSmall = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
  );
}
