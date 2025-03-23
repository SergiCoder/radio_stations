import 'package:radio_stations/features/radio/domain/entities/radio_station.dart';

/// Repository interface for audio playback functionality
///
/// This interface defines the core operations needed for radio station playback,
/// abstracting the underlying audio implementation details.
abstract class AudioRepository {
  /// Plays the given radio station
  ///
  /// [station] is the radio station to play
  /// Returns a [Future] that completes when playback starts
  Future<void> play(RadioStation station);

  /// Toggles the play/pause state of the audio player
  ///
  /// Returns a [Future] that completes when playback is toggled
  Future<void> togglePlayPause();

  /// Gets whether the audio is currently playing
  ///
  /// Returns true if audio is playing, false otherwise
  bool get isPlaying;

  /// Gets a stream of playback state changes
  ///
  /// Returns a stream that emits the current playing state whenever it changes
  Stream<bool> get playingStateStream;

  /// Sets the volume level
  ///
  /// [volume] is the volume level between 0.0 and 1.0
  Future<void> setVolume(double volume);

  /// Gets the current volume level
  ///
  /// Returns the volume level between 0.0 and 1.0
  double get volume;

  /// Disposes of the audio resources
  ///
  /// This should be called when the audio repository is no longer needed
  Future<void> dispose();
}
