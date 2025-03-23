import 'dart:async';

import 'package:radio_stations/features/shared/domain/entitites/radio_station.dart';

/// This class provides a centralized way to handle and broadcast error messages
/// to any part of the application that needs to be notified of errors. It uses
/// a broadcast [StreamController] to allow multiple listeners to receive the
/// same error messages.
///
/// Example usage:
/// ```dart
/// // Broadcasting an error
/// errorEventBus.addError('Failed to play audio stream');
///
/// // Listening for errors
/// errorEventBus.stream.listen((error) {
///   print('Received error: $error');
/// });
/// ```
class ErrorEventBus {
  /// Creates a new instance of [ErrorEventBus]
  ///
  /// This constructor initializes the [StreamController] for error messages.
  ErrorEventBus();

  /// The stream controller that manages error message events
  final StreamController<RadioStation> _controller =
      StreamController<RadioStation>.broadcast();

  /// The stream of error messages that can be listened to
  ///
  /// This stream broadcasts error messages to all active listeners.
  /// Each error message is a [String] describing the error that occurred.
  Stream<RadioStation> get stream => _controller.stream;

  /// Broadcasts an error message to all listeners
  ///
  /// [station] is the radio station that caused the error
  void addError(RadioStation station) {
    _controller.add(station);
  }

  /// Closes the stream controller and releases its resources
  ///
  /// This should be called when the error event bus is no longer needed,
  /// typically during application shutdown.
  void dispose() {
    _controller.close();
  }
}
