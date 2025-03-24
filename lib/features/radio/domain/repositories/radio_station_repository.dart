import 'package:radio_stations/features/radio/domain/domain.dart';
import 'package:radio_stations/features/shared/domain/entitites/radio_station.dart';

/// Repository interface for radio stations
///
/// This interface defines the operations that can be performed on radio
/// stations, including syncing, retrieval, and conversion.
abstract class RadioStationRepository {
  /// Synchronizes radio stations from the remote source to the local cache
  ///
  /// Fetches stations from the remote source, stores them in the local cache,
  /// and converts them to domain entities.
  ///
  /// [onProgress] is callback that will be called with the total number of
  /// stations and the number of stations downloaded so far.
  ///
  /// Throws a [RadioStationSyncFailure] if synchronization fails.
  Future<void> syncStations({
    required void Function(int total, int downloaded) onProgress,
  });

  /// Retrieves all radio stations as list items
  ///
  /// [filter] is an optional filter to apply to the results.
  /// Returns a list of [RadioStation] objects representing all stations in the
  /// local cache that match the filter criteria.
  ///
  /// Throws a [RadioStationDataFailure] if station retrieval fails.
  Future<List<RadioStation>> getAllStations(RadioStationFilter? filter);

  /// Gets the list of available countries
  ///
  /// Returns a sorted list of unique country names from all stations.
  /// Throws a [RadioStationDataFailure] if retrieval fails.
  Future<List<String>> getAvailableCountries();

  /// Toggles the favorite status of a station
  ///
  /// [station] is the station to toggle the favorite status for
  Future<void> toggleStationFavorite(RadioStation station);

  /// Toggles the broken status of a station
  ///
  /// [station] is the station to toggle the broken status for
  Future<void> toggleStationBroken(RadioStation station);
}
