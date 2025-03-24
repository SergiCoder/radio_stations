import 'package:radio_stations/features/audio/audio.dart';
import 'package:radio_stations/features/shared/domain/entitites/radio_station.dart';

/// Implementation of the [AudioRepository] interface using [AudioServiceImpl]
///
/// This class provides the concrete implementation of audio playback
/// functionality by delegating to the [AudioServiceImpl]. It acts as a
/// repository layer that abstracts the audio service implementation details
/// from the rest of the application.
class AudioRepositoryImpl implements AudioRepository {
  /// Creates a new instance of [AudioRepositoryImpl]
  ///
  /// The [audioService] parameter is the audio service implementation to use
  /// for playback operations.
  AudioRepositoryImpl({required AudioServiceImpl audioService})
    : _audioService = audioService;

  /// The audio service implementation used for playback operations
  final AudioServiceImpl _audioService;

  @override
  Future<void> play(RadioStation station) async {
    await _audioService.playRadioStation(station: station);
  }

  @override
  Future<void> togglePlayPause() async {
    await _audioService.pause();
  }

  @override
  bool get isPlaying => _audioService.isPlaying;

  @override
  Stream<bool> get playingStateStream =>
      _audioService.playbackState.map((state) => state.playing);

  @override
  Future<void> setVolume(double volume) async {
    await _audioService.setVolume(volume);
  }

  @override
  double get volume => _audioService.volume;

  @override
  Stream<double> get volumeStream => _audioService.volumeStream;

  @override
  Future<void> dispose() async {
    await _audioService.dispose();
  }
}
