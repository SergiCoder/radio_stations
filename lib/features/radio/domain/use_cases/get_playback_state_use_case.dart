import 'package:radio_stations/features/radio/domain/repositories/audio_repository.dart';

/// Use case for getting the current playback state
///
/// This use case provides access to the playback state stream from the audio
/// repository, allowing the presentation layer to react to playback state
/// changes.
class GetPlaybackStateUseCase {
  /// Creates a new instance of [GetPlaybackStateUseCase]
  ///
  /// [audioRepository] is the repository used for audio playback
  const GetPlaybackStateUseCase({required AudioRepository audioRepository})
    : _audioRepository = audioRepository;

  /// The repository used for audio playback
  final AudioRepository _audioRepository;

  /// Gets whether the audio is currently playing
  ///
  /// Returns true if audio is playing, false otherwise
  bool get isPlaying => _audioRepository.isPlaying;

  /// Gets a stream of playback state changes
  ///
  /// Returns a stream that emits the current playing state whenever it changes
  Stream<bool> get playingStateStream => _audioRepository.playingStateStream;
}
