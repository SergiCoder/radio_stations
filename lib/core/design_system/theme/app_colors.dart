import 'package:flutter/material.dart';

/// Application color palette
///
/// This class defines the color scheme used throughout the application,
/// providing a consistent set of colors for different purposes.
class AppColors {
  /// Primary color used for main UI elements
  ///
  /// This color is used for primary actions, key UI elements,
  /// and to establish visual hierarchy.
  static const Color primary = Colors.purple;

  /// Secondary color used for accents and highlights
  ///
  /// This color complements the primary color and is used
  /// for secondary actions and decorative elements.
  static const Color secondary = Colors.purpleAccent;

  /// Surface color used for cards and elevated surfaces
  ///
  /// This color is used for surfaces that appear above the background,
  /// such as cards, dialogs, and modals.
  static const Color surface = Color(0xFF1A1A1A);

  /// Background color used for the main app background
  ///
  /// This color serves as the base color for the application's
  /// background and main surface.
  static const Color background = Colors.black;

  /// Error color used for error states and messages
  ///
  /// This color is used to indicate error states, validation failures,
  /// and critical issues that require user attention.
  static const Color error = Color(0xFFCF6679);

  /// Success color used for success states and messages
  ///
  /// This color is used to indicate successful actions,
  /// completed tasks, and positive outcomes.
  static const Color success = Color(0xFF4CAF50);

  /// Warning color used for warning states and messages
  ///
  /// This color is used to indicate cautionary states,
  /// potential issues, and important notices.
  static const Color warning = Color(0xFFFFA726);

  /// Info color used for info states and messages
  ///
  /// This color is used for informational messages,
  /// neutral states, and general notifications.
  static const Color info = Color(0xFF29B6F6);

  /// Primary text color used for main content
  ///
  /// This color is used for the most important text elements,
  /// such as headings and primary content.
  static const Color textPrimary = Colors.white;

  /// Secondary text color used for supporting content
  ///
  /// This color is used for less prominent text elements,
  /// such as subtitles and secondary information.
  static const Color textSecondary = Color(0xFFB3B3B3);

  /// Tertiary text color used for subtle content
  ///
  /// This color is used for the least prominent text elements,
  /// such as captions and tertiary information.
  static const Color textTertiary = Color(0xFF808080);

  /// Divider color used for separating content
  ///
  /// This color is used for lines that separate different
  /// sections or elements of the UI.
  static const Color divider = Color(0xFF2A2A2A);

  /// Overlay color for modals and dialogs
  ///
  /// This color is used as a semi-transparent overlay
  /// to create visual hierarchy and focus attention
  /// on modal content.
  static const Color overlay = Color(0x80000000);
}
