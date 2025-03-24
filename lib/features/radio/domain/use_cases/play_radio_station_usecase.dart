import 'dart:developer';

import 'package:radio_stations/features/audio/domain/repositories/audio_repository.dart';
import 'package:radio_stations/features/radio/domain/domain.dart';
import 'package:radio_stations/features/shared/domain/entitites/radio_station.dart';

/// Use case for playing a radio station
///
/// This use case handles the playback of a radio station through the audio
/// repository and manages its broken state in the radio station repository.
class PlayRadioStationUseCase {
  /// Creates a new instance of [PlayRadioStationUseCase]
  ///
  /// [radioStationRepository] is the repository used for managing radio stations
  /// [audioRepository] is the repository used for audio playback
  const PlayRadioStationUseCase({
    required RadioStationRepository radioStationRepository,
    required AudioRepository audioRepository,
  }) : _radioStationRepository = radioStationRepository,
       _audioRepository = audioRepository;

  /// The repository used for managing radio stations
  final RadioStationRepository _radioStationRepository;

  /// The repository used for audio playback
  final AudioRepository _audioRepository;

  /// Gets the audio repository instance
  AudioRepository get audioRepository => _audioRepository;

  /// Gets whether a station is currently playing
  ///
  /// Returns true if a station is currently playing, false otherwise.
  /// This is determined by checking the audio repository's playing state.
  bool get isPlaying => _audioRepository.isPlaying;

  /// Plays a radio station
  ///
  /// [station] is the station to play
  ///
  /// Throws a [RadioStationDataFailure] if playback fails.
  Future<void> execute(RadioStation station) async {
    try {
      await _audioRepository.play(station);
      if (station.broken) {
        await _radioStationRepository.toggleStationBroken(station);
      }
    } catch (e) {
      log('Error playing station: $e');
      if (!station.broken) {
        await _radioStationRepository.toggleStationBroken(station);
      }
    }
  }
}
