import 'package:radio_stations/features/radio/domain/entities/radio_station.dart';
import 'package:radio_stations/features/radio/domain/failures/radio_station_failure.dart';
import 'package:radio_stations/features/radio/domain/repositories/audio_repository.dart';
import 'package:radio_stations/features/radio/domain/repositories/radio_station_repository.dart';

/// Use case for getting a radio station by ID and playing it
///
/// This use case retrieves a radio station by its ID and handles its playback
/// through the audio repository.
class GetRadioStationByIdUseCase {
  /// Creates a new instance of [GetRadioStationByIdUseCase]
  ///
  /// [repository] is the repository used for getting radio stations
  /// [audioRepository] is the repository used for audio playback
  const GetRadioStationByIdUseCase({
    required RadioStationRepository repository,
    required AudioRepository audioRepository,
  }) : _repository = repository,
       _audioRepository = audioRepository;

  /// The repository used for getting radio stations
  final RadioStationRepository _repository;

  /// The repository used for audio playback
  final AudioRepository _audioRepository;

  /// Gets the audio repository instance
  AudioRepository get audioRepository => _audioRepository;

  /// Gets whether a station is currently playing
  ///
  /// Returns true if a station is currently playing, false otherwise.
  /// This is determined by checking the audio repository's playing state.
  bool get isPlaying => _audioRepository.isPlaying;

  /// Gets a radio station by ID and plays it
  ///
  /// [stationuuid] is the unique identifier of the station
  ///
  /// Returns the [RadioStation] with the given [stationuuid], or null if no
  /// station is found.
  ///
  /// Throws a [RadioStationDataFailure] if station retrieval fails.
  Future<RadioStation?> execute(String stationuuid) async {
    try {
      final station = await _repository.getStationById(stationuuid);
      if (station != null) {
        await _audioRepository.play(station);
        await _repository.toggleStationBroken(stationuuid);
      }
      return station;
    } catch (e) {
      await _repository.toggleStationBroken(stationuuid);
      return null;
    }
  }
}
