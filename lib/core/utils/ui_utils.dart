import 'package:flutter/material.dart';

/// Utility functions for UI calculations and common patterns
class UIUtils {
  UIUtils._();

  /// Calculates a percentage of the available screen width
  ///
  /// [context] BuildContext used to access MediaQuery
  /// [percentage] Percentage of screen width to calculate (0.0 to 1.0)
  /// Returns the calculated width
  static double getWidthPercentage(BuildContext context, double percentage) {
    assert(
      percentage >= 0 && percentage <= 1,
      'Percentage must be between 0.0 and 1.0',
    );
    return MediaQuery.sizeOf(context).width * percentage;
  }

  /// Calculates a percentage of the available screen height
  ///
  /// [context] BuildContext used to access MediaQuery
  /// [percentage] Percentage of screen height to calculate (0.0 to 1.0)
  /// Returns the calculated height
  static double getHeightPercentage(BuildContext context, double percentage) {
    assert(
      percentage >= 0 && percentage <= 1,
      'Percentage must be between 0.0 and 1.0',
    );
    return MediaQuery.sizeOf(context).height * percentage;
  }

  /// Returns a standard width for narrow content
  ///
  /// Use this for elements that need minimal width, like icons or small elements
  /// [context] BuildContext used to access MediaQuery
  static double getNarrowWidth(BuildContext context) {
    return getWidthPercentage(context, 0.2);
  }

  /// Returns a standard width for medium content
  ///
  /// Use this for elements that need moderate width, like alerts or forms
  /// [context] BuildContext used to access MediaQuery
  static double getMediumWidth(BuildContext context) {
    return getWidthPercentage(context, 0.5);
  }

  /// Returns a standard width for wide content
  ///
  /// Use this for elements that need substantial width, like dialogs or panels
  /// [context] BuildContext used to access MediaQuery
  static double getWideWidth(BuildContext context) {
    return getWidthPercentage(context, 0.8);
  }
}
