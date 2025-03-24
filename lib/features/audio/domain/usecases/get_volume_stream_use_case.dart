import 'package:radio_stations/features/audio/domain/repositories/audio_repository.dart';

/// Use case for getting a stream of volume changes
///
/// This use case provides access to the volume stream from the audio repository,
/// allowing the application to react to volume changes in real-time.
class GetVolumeStreamUseCase {
  /// Creates a new instance of [GetVolumeStreamUseCase]
  ///
  /// The [repository] parameter is the audio repository to use for getting
  /// the volume stream.
  GetVolumeStreamUseCase({required AudioRepository repository})
    : _repository = repository;

  /// The audio repository used for getting the volume stream
  final AudioRepository _repository;

  /// Gets a stream of volume changes
  ///
  /// Returns a stream that emits the current volume level whenever it changes.
  /// The volume level is between 0.0 and 1.0.
  Stream<double> call() => _repository.volumeStream;
}
