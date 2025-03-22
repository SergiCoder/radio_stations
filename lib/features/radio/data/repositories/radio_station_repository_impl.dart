import 'package:radio_stations/features/radio/data/datasources/radio_station_local_data_source.dart';
import 'package:radio_stations/features/radio/data/datasources/radio_station_remote_data_source.dart';
import 'package:radio_stations/features/radio/data/dto/radio_station_local_dto.dart';
import 'package:radio_stations/features/radio/data/dto/radio_station_remote_dto.dart';
import 'package:radio_stations/features/radio/domain/domain.dart';

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
    final stations = await remoteDataSource.getStations(
      onProgress: onProgress,
    );

    // Process stations in a single pass
    final localStations = <RadioStationLocalDto>[];

    for (final station in stations) {
      // Convert to local DTO
      localStations.add(_toLocalDto(station));
    }

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
          isFavorite: toggleFavorite
              ? !localStation.isFavorite
              : localStation.isFavorite,
          broken: toggleBroken ? !localStation.broken : localStation.broken,
        );
        await localDataSource.saveStation(updatedStation);
        return _toEntity(updatedStation);
      }

      return _toEntity(localStation);
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
      return stations.map(_toListItem).toList();
    }

    // Filter stations first
    final filteredStations = stations.where((station) {
      if (filter.favorite && !station.isFavorite) {
        return false;
      }
      if (filter.country != null && station.country != filter.country) {
        return false;
      }
      return true;
    }).toList();

    // Then convert to list items
    return filteredStations.map(_toListItem).toList();
  }

  @override
  Future<List<String>> getAvailableCountries() async {
    try {
      final stations = localDataSource.getAllStations();
      final countries = stations
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

  /// Converts a [RadioStationRemoteDto] to a [RadioStationLocalDto]
  ///
  /// The [dto] parameter is the remote DTO to convert.
  /// Returns a new [RadioStationLocalDto] instance.
  RadioStationLocalDto _toLocalDto(RadioStationRemoteDto dto) {
    // Get existing station to preserve favorite and broken status
    final existingStation = localDataSource.getStationById(dto.stationuuid);

    return RadioStationLocalDto(
      changeuuid: dto.stationuuid,
      name: dto.name,
      url: dto.url,
      homepage: dto.homepage,
      favicon: dto.favicon,
      country: dto.country,
      isFavorite: existingStation?.isFavorite ?? false,
      broken: existingStation?.broken ?? false,
    );
  }

  /// Converts a [RadioStationLocalDto] to a [RadioStation] domain entity
  ///
  /// The [dto] parameter is the local DTO to convert.
  /// Returns a new [RadioStation] instance.
  RadioStation _toEntity(RadioStationLocalDto dto) {
    return RadioStation.create(
      uuid: dto.changeuuid,
      name: dto.name,
      url: dto.url,
      homepage: dto.homepage,
      favicon: dto.favicon,
      country: dto.country,
      favorite: dto.isFavorite,
      broken: dto.broken,
    )!;
  }

  /// Converts a [RadioStationLocalDto] to a [RadioStationListItem]
  ///
  /// The [dto] parameter is the local DTO to convert.
  /// Returns a new [RadioStationListItem] instance.
  RadioStationListItem _toListItem(RadioStationLocalDto dto) {
    return RadioStationListItem(
      uuid: dto.changeuuid,
      name: dto.name,
      favorite: dto.isFavorite,
      broken: dto.broken,
      favicon: dto.favicon,
    );
  }
}
