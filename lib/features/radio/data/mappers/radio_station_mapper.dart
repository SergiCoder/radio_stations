import 'dart:developer';

import 'package:radio_stations/features/radio/data/dto/radio_station_local_dto.dart';
import 'package:radio_stations/features/radio/domain/entities/radio_station.dart';

/// Mapper for converting between RadioStationLocalDto and RadioStation entity
///
/// This class handles the conversion of radio station data from the local
/// storage format to domain entities. It includes validation to ensure data
/// integrity and proper formatting.
class RadioStationMapper {
  /// Creates a new instance of [RadioStationMapper]
  RadioStationMapper();

  /// Converts a list of RadioStationLocalDto to a list of RadioStation entities
  ///
  /// Returns a list containing only the valid stations.
  /// Logs the number of stations that were discarded due to invalid data.
  List<RadioStation> toEntities(List<RadioStationLocalDto> dtos) {
    final totalStations = dtos.length;
    final validStations =
        dtos.map(toEntityFromLocal).whereType<RadioStation>().toList();
    final discardedStations = totalStations - validStations.length;

    log(
      '''Discarded $discardedStations out of $totalStations stations due to invalid data''',
    );

    return validStations;
  }

  /// Converts a RadioStationLocalDto to a RadioStation entity
  ///
  /// Returns null if the conversion fails or the station is invalid.
  /// The validation includes checking UUID format and URL validity.
  RadioStation? toEntityFromLocal(RadioStationLocalDto dto) {
    return RadioStation.create(
      uuid: dto.changeuuid,
      name: dto.name,
      url: dto.url,
      homepage: dto.homepage,
      favicon: dto.favicon,
      country: dto.country,
    );
  }
}
