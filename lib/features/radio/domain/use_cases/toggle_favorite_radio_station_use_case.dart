import 'package:radio_stations/features/radio/domain/repositories/radio_station_repository.dart';

/// Use case for toggling the favorite status of a radio station
class ToggleFavoriteRadioStationUseCase {
  /// Creates a new instance of [ToggleFavoriteRadioStationUseCase]
  ///
  /// [repository] is the repository to use for radio station operations
  const ToggleFavoriteRadioStationUseCase({
    required this.repository,
  });

  /// The repository to use for radio station operations
  final RadioStationRepository repository;

  /// Toggles the favorite status of a radio station
  ///
  /// [stationId] is the ID of the station to toggle
  Future<void> execute(String stationId) async {
    await repository.toggleStationFavorite(stationId);
  }
}
