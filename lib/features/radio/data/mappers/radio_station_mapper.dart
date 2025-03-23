import 'package:radio_stations/features/radio/data/dto/radio_station_local_dto.dart';
import 'package:radio_stations/features/radio/data/dto/radio_station_remote_dto.dart';
import 'package:radio_stations/features/radio/domain/domain.dart';

/// Mapper class for converting between different radio station data types
///
/// This class handles all conversions between:
/// - Remote DTOs (from API)
/// - Local DTOs (from database)
/// - Domain entities
/// - List items (for UI)
class RadioStationMapper {
  /// Converts a [RadioStationRemoteDto] to a [RadioStationLocalDto]
  ///
  /// The [remoteDto] parameter is the remote DTO to convert.
  /// The [existingLocalDto] parameter is an optional existing local DTO to preserve state.
  /// Returns a new [RadioStationLocalDto] instance.
  static RadioStationLocalDto toLocalDto(
    RadioStationRemoteDto remoteDto, {
    RadioStationLocalDto? existingLocalDto,
  }) {
    return RadioStationLocalDto(
      changeuuid: remoteDto.changeuuid ?? remoteDto.stationuuid,
      name: remoteDto.name,
      url: remoteDto.url,
      homepage: remoteDto.homepage,
      favicon: remoteDto.favicon,
      country: remoteDto.country,
      isFavorite: existingLocalDto?.isFavorite ?? false,
      broken: existingLocalDto?.broken ?? false,
    );
  }

  /// Converts a [RadioStationLocalDto] to a [RadioStation] domain entity
  ///
  /// The [localDto] parameter is the local DTO to convert.
  /// Returns a new [RadioStation] instance.
  static RadioStation toEntity(RadioStationLocalDto localDto) {
    return RadioStation.create(
      uuid: localDto.changeuuid,
      name: localDto.name,
      url: localDto.url,
      homepage: localDto.homepage,
      favicon: localDto.favicon,
      country: localDto.country,
      favorite: localDto.isFavorite,
      broken: localDto.broken,
    )!;
  }

  /// Converts a [RadioStationLocalDto] to a [RadioStationListItem]
  ///
  /// The [localDto] parameter is the local DTO to convert.
  /// Returns a new [RadioStationListItem] instance.
  static RadioStationListItem toListItem(RadioStationLocalDto localDto) {
    return RadioStationListItem(
      uuid: localDto.changeuuid,
      name: localDto.name,
      favorite: localDto.isFavorite,
      broken: localDto.broken,
      favicon: localDto.favicon,
    );
  }

  /// Converts a list of [RadioStationLocalDto] to a list of [RadioStationListItem]
  ///
  /// The [localDtos] parameter is the list of local DTOs to convert.
  /// Returns a new list of [RadioStationListItem] instances.
  static List<RadioStationListItem> toListItems(
    List<RadioStationLocalDto> localDtos,
  ) {
    return localDtos.map(toListItem).toList();
  }
}
