import 'package:flutter/material.dart';

/// Utility functions for input handling
class InputUtils {
  /// Private constructor to prevent instantiation
  InputUtils._();

  /// Unfocuses the current focus and then executes the provided callback
  ///
  /// This is useful for ensuring the keyboard is dismissed when interacting
  /// with UI elements like list items or buttons.
  ///
  /// [context] is the build context used to access the current focus scope
  /// [callback] is the function to execute after unfocusing
  static void unfocusAndThen(BuildContext context, VoidCallback callback) {
    // First unfocus any current focus
    FocusScope.of(context).unfocus();

    // Then execute the callback
    callback();
  }
}
