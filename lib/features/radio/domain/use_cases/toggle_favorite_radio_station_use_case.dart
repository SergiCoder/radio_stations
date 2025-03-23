import 'package:radio_stations/features/radio/domain/domain.dart';

/// Use case for toggling the favorite status of a radio station
class ToggleFavoriteRadioStationUseCase {
  /// Creates a new instance of [ToggleFavoriteRadioStationUseCase]
  ///
  /// [repository] is the repository to use for radio station operations
  const ToggleFavoriteRadioStationUseCase({required this.repository});

  /// The repository to use for radio station operations
  final RadioStationRepository repository;

  /// Toggles the favorite status of a radio station
  ///
  /// [station] is the station to toggle
  Future<void> execute(RadioStation station) async {
    await repository.toggleStationFavorite(station);
  }
}
