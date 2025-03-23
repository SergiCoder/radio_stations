import 'dart:async';

import 'package:radio_stations/features/radio/domain/domain.dart';

/// Use case for marking radio stations as broken based on error events
///
/// It uses the [RadioStationRepository] to update thstation's broken status.
class SetBrokenRadioStationUseCase {
  /// Creates a new instance of [SetBrokenRadioStationUseCase]
  ///
  /// [radioStationRepository] is the repository used for managing radio stations
  SetBrokenRadioStationUseCase({
    required RadioStationRepository radioStationRepository,
  }) : _radioStationRepository = radioStationRepository;

  /// The repository used for managing radio stations
  final RadioStationRepository _radioStationRepository;

  /// Handles error events by marking the corresponding radio station as broken
  ///
  /// [station] is the radio station that caused the error
  Future<void> execute(RadioStation station) async {
    if (station.broken) {
      return;
    }
    await _radioStationRepository.toggleStationBroken(station);
  }
}
