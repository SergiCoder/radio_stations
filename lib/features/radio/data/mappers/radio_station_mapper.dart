import 'dart:developer';

import 'package:radio_stations/core/utils/validators.dart';
import 'package:radio_stations/features/radio/radio.dart';
import 'package:radio_stations/features/shared/shared.dart';

/// Mapper class for converting between different radio station data types
///
/// This class handles all conversions between:
/// - Remote DTOs (from API)
/// - Local DTOs (from database)
/// - Domain entities
///
/// It also handles all validation to ensure that only valid data is passed to the domain layer.
class RadioStationMapper {
  /// Creates a new instance of [RadioStationMapper]
  ///
  /// [validators] is the service used to validate data during mapping
  const RadioStationMapper({required this.validators});

  /// The validator instance used to validate data during mapping
  final Validators validators;

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
    List<RadioStationLocalDto> existingLocalDtos = const [],
  }) {
    // Create a map for O(1) lookups by UUID
    final existingMap = {
      for (final dto in existingLocalDtos) dto.changeuuid: dto,
    };

    return remoteDtos.map((remoteDto) {
      // Check if we have an existing entry with the same UUID
      final existing =
          existingMap[remoteDto.changeuuid ?? remoteDto.stationuuid];

      // Create a new local DTO, preserving favorite and broken status if it exists
      return RadioStationLocalDto(
        changeuuid: remoteDto.changeuuid ?? remoteDto.stationuuid,
        name: remoteDto.name,
        url: remoteDto.url,
        homepage: remoteDto.homepage,
        favicon: remoteDto.favicon,
        country: remoteDto.country,
        // Preserve metadata from existing entries or set defaults
        isFavorite: existing?.isFavorite ?? false,
        broken: existing?.broken ?? false,
      );
    }).toList();
  }

  /// Converts a [RadioStationLocalDto] to a [RadioStation] domain entity
  ///
  /// The [localDto] parameter is the local DTO to convert.
  /// Returns a new [RadioStation] instance.
  /// Throws [RadioStationMappingFailure] if validation fails.
  RadioStation toEntity(RadioStationLocalDto localDto) {
    try {
      // Validate UUID
      if (!validators.isValidUuid(localDto.changeuuid)) {
        throw const RadioStationMappingFailure('Invalid UUID format');
      }

      // Validate URL
      if (!validators.isValidUrl(localDto.url)) {
        throw const RadioStationMappingFailure('Invalid stream URL');
      }

      // Clean and validate other fields
      final name =
          localDto.name.trim().isEmpty
              ? 'Unknown Station'
              : localDto.name.trim();

      final homepage =
          validators.isValidUrl(localDto.homepage) ? localDto.homepage : '';

      final favicon =
          validators.isValidUrl(localDto.favicon) ? localDto.favicon : '';

      // Create the entity with validated data
      return RadioStation(
        uuid: localDto.changeuuid,
        name: name,
        url: localDto.url,
        homepage: homepage,
        favicon: favicon,
        country: localDto.country,
        isFavorite: localDto.isFavorite,
        broken: localDto.broken,
      );
    } catch (e) {
      throw RadioStationMappingFailure('Failed to map local DTO to entity: $e');
    }
  }

  /// Converts a list of [RadioStationLocalDto] to a list of [RadioStation] domain entities
  ///
  /// The [localDtos] parameter is the list of local DTOs to convert.
  /// Returns a new list of [RadioStation] instances, skipping any invalid entities.
  List<RadioStation> toEntities(List<RadioStationLocalDto> localDtos) {
    final entities = <RadioStation>[];

    for (final dto in localDtos) {
      try {
        entities.add(toEntity(dto));
      } catch (e) {
        // Log the error but continue processing other entities
        log('Skipping invalid entity: $e');
      }
    }

    return entities;
  }

  /// Converts a [RadioStation] entity to a [RadioStationLocalDto] for storage
  ///
  /// The [entity] parameter is the domain entity to convert.
  /// Returns a new [RadioStationLocalDto] instance.
  RadioStationLocalDto fromEntity(RadioStation entity) {
    return RadioStationLocalDto(
      changeuuid: entity.uuid,
      name: entity.name,
      url: entity.url,
      homepage: entity.homepage,
      favicon: entity.favicon,
      country: entity.country,
      isFavorite: entity.isFavorite,
      broken: entity.broken,
    );
  }
}
