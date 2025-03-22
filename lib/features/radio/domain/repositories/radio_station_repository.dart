import 'package:radio_stations/features/radio/domain/domain.dart';

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
  /// [onProgress] is an optional callback that will be called with the total
  /// number of stations and the number of stations downloaded so far.
  ///
  /// Throws a [RadioStationSyncFailure] if synchronization fails.
  Future<void> syncStations({
    void Function(int total, int downloaded)? onProgress,
  });

  /// Retrieves a radio station by its unique identifier
  ///
  /// [changeuuid] is the unique identifier for the station.
  /// [toggleFavorite] if true, toggles the favorite status of the station.
  /// [toggleBroken] if true, toggles the broken status of the station.
  ///
  /// Returns the [RadioStation] with the given [changeuuid], or null if no
  /// station is found.
  ///
  /// Throws a [RadioStationDataFailure] if station retrieval fails.
  Future<RadioStation?> getStationById(
    String changeuuid, {
    bool toggleFavorite = false,
    bool toggleBroken = false,
  });

  /// Retrieves all radio stations as list items
  ///
  /// [filter] is an optional filter to apply to the results.
  /// Returns a list of [RadioStationListItem] objects representing all
  /// stations in the local cache that match the filter criteria.
  ///
  /// Throws a [RadioStationDataFailure] if station retrieval fails.
  Future<List<RadioStationListItem>> getAllListItems([
    RadioStationListItemsFilter? filter,
  ]);

  /// Gets the list of available countries
  ///
  /// Returns a sorted list of unique country names from all stations.
  /// Throws a [RadioStationDataFailure] if retrieval fails.
  Future<List<String>> getAvailableCountries();

  /// Toggles the favorite status of a station
  ///
  /// [stationId] is the ID of the station to toggle the favorite status for
  Future<void> toggleStationFavorite(String stationId);

  /// Toggles the broken status of a station
  ///
  /// [stationId] is the ID of the station to toggle the broken status for
  Future<void> toggleStationBroken(String stationId);
}
