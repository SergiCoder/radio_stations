import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:radio_stations/core/constants/app_constants.dart';

/// A utility class to debounce rapid events
///
/// This class helps prevent rapid event firing by delaying execution
/// of actions until a specified timeout has passed without new events.
/// Common use cases include search input debouncing to reduce API calls.
class Debouncer {
  /// Creates a new instance of [Debouncer]
  ///
  /// [milliseconds] is the delay duration in milliseconds.
  /// The default value is defined in AppConstants.
  Debouncer({this.milliseconds = AppConstants.defaultDebounceDuration});

  /// The delay duration in milliseconds
  final int milliseconds;

  Timer? _timer;

  /// Run the provided callback after the debounce period
  ///
  /// If this method is called again before the timeout period ends,
  /// the previous callback will be canceled and a new timeout will start.
  void run(VoidCallback action) {
    _timer?.cancel();
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }

  /// Cancel any pending callbacks
  ///
  /// This should be called when the object owning the debouncer is disposed
  /// to prevent memory leaks.
  void dispose() {
    _timer?.cancel();
  }
}
