import 'dart:developer';

import 'package:radio_stations/features/radio/data/datasources/radio_station_local_data_source.dart';
import 'package:radio_stations/features/radio/data/datasources/radio_station_remote_data_source.dart';
import 'package:radio_stations/features/radio/data/dto/radio_station_local_dto.dart';
import 'package:radio_stations/features/radio/data/mappers/radio_station_mapper.dart';
import 'package:radio_stations/features/radio/domain/domain.dart';
import 'package:radio_stations/features/radio/domain/extensions/radio_station_list_item_extensions.dart';

/// Implementation of [RadioStationRepository]
///
/// This class handles the business logic for radio station operations,
/// coordinating between remote and local data sources.
class RadioStationRepositoryImpl implements RadioStationRepository {
  /// Creates a new instance of [RadioStationRepositoryImpl]
  ///
  /// The [remoteDataSource] parameter is the remote data source for radio stations.
  /// The [localDataSource] parameter is the local data source for radio stations.
  RadioStationRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  /// The remote data source for radio stations
  final RadioStationRemoteDataSource remoteDataSource;

  /// The local data source for radio stations
  final RadioStationLocalDataSource localDataSource;

  @override
  Future<void> syncStations({
    void Function(int total, int downloaded)? onProgress,
  }) async {
    final stations = await remoteDataSource.getStations(onProgress: onProgress);

    var counter = 0;

    // Process stations in a single pass
    final localStations = <RadioStationLocalDto>[];

    for (final station in stations) {
      // Remove video stations
      if (station.hls == 0) {
        // Get existing station to preserve state
        final existingStation = localDataSource.getStationById(
          station.stationuuid,
        );

        // Convert to local DTO
        final localDto = RadioStationMapper.toLocalDto(
          station,
          existingLocalDto: existingStation,
        );
        localStations.add(localDto);
      } else {
        counter++;
      }
    }
    log('Discarded $counter radio stations because HLS content');
    await localDataSource.deleteAllStations();
    await localDataSource.saveStations(localStations);
  }

  @override
  Future<RadioStation?> getStationById(
    String changeuuid, {
    bool toggleFavorite = false,
    bool toggleBroken = false,
  }) async {
    try {
      final localStation = localDataSource.getStationById(changeuuid);
      if (localStation == null) return null;

      // Apply toggle operations if requested
      if (toggleFavorite || toggleBroken) {
        final updatedStation = localStation.copyWith(
          isFavorite:
              toggleFavorite
                  ? !localStation.isFavorite
                  : localStation.isFavorite,
          broken: toggleBroken ? !localStation.broken : localStation.broken,
        );
        await localDataSource.saveStation(updatedStation);
        return RadioStationMapper.toEntity(updatedStation);
      }

      return RadioStationMapper.toEntity(localStation);
    } catch (e) {
      throw RadioStationDataFailure('Failed to get station: $e');
    }
  }

  @override
  Future<List<RadioStationListItem>> getAllListItems([
    RadioStationListItemsFilter? filter,
  ]) async {
    final stations = localDataSource.getAllStations();

    if (filter == null) {
      final listItems = RadioStationMapper.toListItems(stations);
      return listItems.orderByName();
    }

    // Filter stations first
    final filteredStationsDtos =
        stations.where((station) {
          if (filter.favorite && !station.isFavorite) {
            return false;
          }
          if (filter.country != null && station.country != filter.country) {
            return false;
          }
          return true;
        }).toList();

    final listItems = RadioStationMapper.toListItems(filteredStationsDtos);
    return listItems.orderByName();
  }

  @override
  Future<List<String>> getAvailableCountries() async {
    try {
      final stations = localDataSource.getAllStations();
      final countries =
          stations
              .map((s) => s.country)
              .where((c) => c.isNotEmpty)
              .toSet()
              .toList()
            ..sort();
      return countries;
    } catch (e) {
      throw RadioStationDataFailure('Failed to get available countries: $e');
    }
  }

  @override
  Future<void> toggleStationFavorite(String stationId) async {
    try {
      await localDataSource.toggleStationFavorite(stationId);
    } catch (e) {
      throw RadioStationDataFailure('Failed to toggle favorite status: $e');
    }
  }

  @override
  Future<void> toggleStationBroken(String stationId) async {
    try {
      await localDataSource.toggleStationBroken(stationId);
    } catch (e) {
      throw RadioStationDataFailure('Failed to toggle broken status: $e');
    }
  }
}
