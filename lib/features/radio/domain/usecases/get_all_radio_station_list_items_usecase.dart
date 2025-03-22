import 'package:radio_stations/features/radio/domain/domain.dart';

/// Use case for retrieving all radio station list items
///
/// This use case is responsible for retrieving all radio station list items
/// from the local cache. It handles the business logic for fetching and error
/// handling during retrieval.
class GetAllRadioStationListItemsUseCase {
  /// Creates a new instance of [GetAllRadioStationListItemsUseCase]
  ///
  /// [repository] is the repository used for retrieving radio station list
  /// items
  const GetAllRadioStationListItemsUseCase({
    required RadioStationRepository repository,
  }) : _repository = repository;

  /// The repository used for retrieving radio station list items
  final RadioStationRepository _repository;

  /// Retrieves all radio station list items
  ///
  /// [filter] is an optional filter to apply to the results.
  /// Returns a list of [RadioStationListItem] objects representing all
  /// stations in the local cache that match the filter criteria.
  ///
  /// Throws a [RadioStationDataFailure] if station retrieval fails
  Future<List<RadioStationListItem>> execute([
    RadioStationListItemsFilter? filter,
  ]) async {
    try {
      return await _repository.getAllListItems(filter);
    } catch (e) {
      throw RadioStationDataFailure(
        'Failed to get radio station list items: $e',
      );
    }
  }

  /// Gets the list of available countries
  ///
  /// Returns a sorted list of unique country names from all stations.
  /// Throws a [RadioStationDataFailure] if retrieval fails.
  Future<List<String>> getAvailableCountries() async {
    try {
      return await _repository.getAvailableCountries();
    } catch (e) {
      throw RadioStationDataFailure(
        'Failed to get available countries: $e',
      );
    }
  }

  /// Toggles the favorite status of a station
  ///
  /// [stationId] is the ID of the station to toggle the favorite status for
  Future<void> toggleStationFavorite(String stationId) async {
    await _repository.toggleStationFavorite(stationId);
  }
}
