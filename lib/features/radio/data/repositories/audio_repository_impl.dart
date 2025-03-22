import 'package:radio_stations/features/radio/data/services/audio_service_impl.dart';
import 'package:radio_stations/features/radio/domain/entities/radio_station.dart';
import 'package:radio_stations/features/radio/domain/repositories/audio_repository.dart';

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
    await _audioService.playRadioStation(station);
  }

  @override
  Future<void> stop() async {
    await _audioService.stop();
  }

  @override
  bool get isPlaying => _audioService.isPlaying;

  @override
  Future<void> setVolume(double volume) async {
    await _audioService.setVolume(volume);
  }

  @override
  double get volume => _audioService.volume;

  @override
  Future<void> dispose() async {
    await _audioService.dispose();
  }
}
