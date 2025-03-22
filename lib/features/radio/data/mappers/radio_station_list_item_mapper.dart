import 'dart:developer';

import 'package:radio_stations/core/utils/validators.dart';
import 'package:radio_stations/features/radio/data/dto/radio_station_local_dto.dart';
import 'package:radio_stations/features/radio/domain/entities/radio_station_list_item.dart';

/// Mapper for converting between RadioStationLocalDto and RadioStationListItem
///
/// This class handles the conversion of radio station data from the local storage
/// format to lightweight list items used in the UI. It includes validation to
/// ensure only valid stations are included in the list.
class RadioStationListItemMapper {
  /// Creates a new instance of [RadioStationListItemMapper]
  RadioStationListItemMapper();

  /// Converts a list of RadioStationLocalDto to a list of RadioStationListItem
  ///
  /// This method converts local DTOs to lightweight list items for UI display.
  /// It performs validation to ensure only valid stations are included:
  /// - Checks that the station UUID is not empty
  /// - Checks that the station name is not empty
  ///
  /// Returns a list of [RadioStationListItem] objects containing only the valid
  /// stations. Invalid stations are logged and discarded.
  List<RadioStationListItem> toListItemsFromLocal(
    List<RadioStationLocalDto> dtos,
  ) {
    final totalStations = dtos.length;
    final validStations = dtos
        .where(
          (dto) =>
              Validators.isValidUuid(dto.changeuuid) || dto.name.isNotEmpty,
        )
        .map(
          (dto) => RadioStationListItem(
            uuid: dto.changeuuid,
            name: dto.name,
            favorite: dto.isFavorite,
            broken: dto.broken,
            favicon: dto.favicon,
          ),
        )
        .toList();
    final discardedStations = totalStations - validStations.length;

    log(
      '''Discarded $discardedStations out of $totalStations stations due to empty stationuuids or names''',
    );

    return validStations;
  }
}
