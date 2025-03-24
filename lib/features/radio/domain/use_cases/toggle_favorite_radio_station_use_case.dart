import 'package:radio_stations/features/radio/domain/domain.dart';
import 'package:radio_stations/features/shared/domain/entitites/radio_station.dart';

/// Use case for toggling the favorite status of a radio station
class ToggleFavoriteRadioStationUseCase {
  /// Creates a new instance of [ToggleFavoriteRadioStationUseCase]
  ///
  /// [radioStationRepository] is the repository to use for radio station
  /// operations
  const ToggleFavoriteRadioStationUseCase({
    required RadioStationRepository radioStationRepository,
  }) : _radioStationRepository = radioStationRepository;

  /// The repository to use for radio station operations
  final RadioStationRepository _radioStationRepository;

  /// Toggles the favorite status of a radio station
  ///
  /// [station] is the station to toggle
  Future<void> execute(RadioStation station) async {
    await _radioStationRepository.toggleStationFavorite(station);
  }
}
