import 'package:radio_stations/features/radio/radio.dart';
import 'package:radio_stations/features/shared/shared.dart';

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
    required this.mapper,
  });

  /// The remote data source for radio stations
  final RadioStationRemoteDataSource remoteDataSource;

  /// The local data source for radio stations
  final RadioStationLocalDataSource localDataSource;

  /// The mapper for radio stations
  final RadioStationMapper mapper;

  @override
  Future<void> syncStations({
    required void Function(int total, int downloaded) onProgress,
  }) async {
    final remoteStations = await remoteDataSource.getStations(
      onProgress: onProgress,
    );
    // Remove HLS stations due to video content
    final nonHlsStations = remoteStations.removeHlsStations();

    // Fetch all stations from local data source
    final localStations = localDataSource.getAllStations();
    // Convert to local DTOs and preserve existing stations favorites and
    // broken status
    final updatedStations = mapper.toLocalDtos(
      nonHlsStations,
      existingLocalDtos: localStations,
    );
    // Delete all existing stations
    await localDataSource.deleteAllStations();
    // Save new stations
    await localDataSource.saveStations(updatedStations);
  }

  @override
  Future<List<RadioStation>> getAllStations(RadioStationFilter? filter) async {
    final stations = localDataSource.getAllStations();

    if (filter == null) {
      final listItems = mapper.toEntities(stations);
      return listItems;
    }

    // Filter stations first
    final filteredStationsDtos =
        stations.where((station) {
          // Filter by favorites
          if (filter.favorite && !station.isFavorite) {
            return false;
          }

          // Filter by country
          if (filter.country != null && station.country != filter.country) {
            return false;
          }

          // Filter by search term
          if (filter.searchTerm.isNotEmpty &&
              !station.name.toLowerCase().contains(
                filter.searchTerm.toLowerCase(),
              )) {
            return false;
          }

          return true;
        }).toList();

    final listItems = mapper.toEntities(filteredStationsDtos).orderByName();
    return listItems;
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
  Future<void> toggleStationFavorite(RadioStation station) async {
    try {
      await localDataSource.toggleStationFavorite(station);
    } catch (e) {
      throw RadioStationDataFailure('Failed to toggle favorite status: $e');
    }
  }

  @override
  Future<void> toggleStationBroken(RadioStation station) async {
    try {
      await localDataSource.toggleStationBroken(station);
    } catch (e) {
      throw RadioStationDataFailure('Failed to toggle broken status: $e');
    }
  }
}
