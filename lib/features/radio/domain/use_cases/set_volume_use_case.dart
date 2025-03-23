import 'package:radio_stations/features/audio/domain/repositories/audio_repository.dart';

/// Use case for controlling the audio volume
///
/// This use case provides functionality to get and set the audio volume
/// through the audio repository.
class SetVolumeUseCase {
  /// Creates a new instance of [SetVolumeUseCase]
  ///
  /// [audioRepository] is the repository used for audio playback
  const SetVolumeUseCase({required AudioRepository audioRepository})
    : _audioRepository = audioRepository;

  /// The repository used for audio playback
  final AudioRepository _audioRepository;

  /// Gets the current volume level
  ///
  /// Returns the volume level between 0.0 and 1.0
  double get volume => _audioRepository.volume;

  /// Sets the volume level
  ///
  /// [volume] is the volume level between 0.0 and 1.0
  Future<void> execute(double volume) async {
    await _audioRepository.setVolume(volume);
  }
}
