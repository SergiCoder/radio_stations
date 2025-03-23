import 'dart:developer';

import 'package:radio_stations/features/radio/data/dto/radio_station_local_dto.dart';
import 'package:radio_stations/features/radio/data/dto/radio_station_remote_dto.dart';
import 'package:radio_stations/features/radio/domain/domain.dart';

/// Mapper class for converting between different radio station data types
///
/// This class handles all conversions between:
/// - Remote DTOs (from API)
/// - Local DTOs (from database)
/// - Domain entities
class RadioStationMapper {
  /// Converts a [RadioStationRemoteDto] to a [RadioStationLocalDto]
  ///
  /// The [remoteDto] parameter is the remote DTO to convert.
  /// The [existingLocalDto] parameter is an optional existing local DTO to preserve state.
  /// Returns a new [RadioStationLocalDto] instance.
  RadioStationLocalDto toLocalDto(
    RadioStationRemoteDto remoteDto, {
    RadioStationLocalDto? existingLocalDto,
  }) {
    return RadioStationLocalDto(
      changeuuid: remoteDto.changeuuid ?? remoteDto.stationuuid,
      name: remoteDto.name.trim(),
      url: remoteDto.url,
      homepage: remoteDto.homepage,
      favicon: remoteDto.favicon,
      country: remoteDto.country,
      isFavorite: existingLocalDto?.isFavorite ?? false,
      broken: existingLocalDto?.broken ?? false,
    );
  }

  /// Converts a list of [RadioStationRemoteDto] to a list of [RadioStationLocalDto]
  ///
  /// The [remoteDtos] parameter is the list of remote DTOs to convert.
  /// The [existingLocalDtos] parameter is an optional map of existing local DTOs to preserve state.
  /// Returns a new list of [RadioStationLocalDto] instances.
  List<RadioStationLocalDto> toLocalDtos(
    List<RadioStationRemoteDto> remoteDtos, {
    List<RadioStationLocalDto>? existingLocalDtos,
  }) {
    try {
      final existingLocalDtosMap = existingLocalDtos
          ?.fold<Map<String, RadioStationLocalDto>>({}, (map, dto) {
            map[dto.changeuuid] = dto;
            return map;
          });

      return remoteDtos.map((dto) {
        final existingDto = existingLocalDtosMap?[dto.changeuuid];
        return toLocalDto(dto, existingLocalDto: existingDto);
      }).toList();
    } catch (e) {
      log('Error converting remote DTOs to local DTOs: $e');
      return [];
    }
  }

  /// Converts a [RadioStationLocalDto] to a [RadioStation] domain entity
  ///
  /// The [localDto] parameter is the local DTO to convert.
  /// Returns a new [RadioStation] instance.
  RadioStation toEntity(RadioStationLocalDto localDto) {
    try {
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
    } catch (e) {
      log('Error converting local DTO to entity: $e');
      rethrow;
    }
  }

  /// Converts a list of [RadioStationLocalDto] to a list of [RadioStation] domain entities
  ///
  /// The [localDtos] parameter is the list of local DTOs to convert.
  /// Returns a new list of [RadioStation] instances.
  List<RadioStation> toEntities(List<RadioStationLocalDto> localDtos) {
    return localDtos.map(toEntity).toList();
  }
}
