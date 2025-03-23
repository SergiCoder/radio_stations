import 'package:radio_stations/features/audio/domain/repositories/audio_repository.dart';

/// Use case for toggling play/pause state of the audio player
class TogglePlayPauseUseCase {
  /// Creates a new instance of [TogglePlayPauseUseCase]
  const TogglePlayPauseUseCase({required AudioRepository audioRepository})
    : _audioRepository = audioRepository;

  /// The audio repository to use for playback control
  final AudioRepository _audioRepository;

  /// Toggles the play/pause state of the audio player
  Future<void> execute() async => _audioRepository.togglePlayPause();
}
