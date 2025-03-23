import 'dart:developer';

import 'package:radio_stations/features/radio/domain/failures/radio_station_failure.dart';
import 'package:radio_stations/features/radio/domain/repositories/radio_station_repository.dart';

/// Use case for synchronizing radio stations
///
/// This use case is responsible for synchronizing radio stations from
/// the remote source to the local cache. It handles the business logic
/// for fetching, storing, and error handling during synchronization.
class SyncRadioStationsUseCase {
  /// Creates a new instance of [SyncRadioStationsUseCase]
  ///
  /// [radioStationRepository] is the repository used for synchronizing radio
  /// stations
  const SyncRadioStationsUseCase({
    required RadioStationRepository radioStationRepository,
  }) : _radioStationRepository = radioStationRepository;

  /// The repository used for synchronizing radio stations
  final RadioStationRepository _radioStationRepository;

  /// Synchronizes radio stations from the remote source to the local cache
  ///
  /// This method delegates to the repository to sync stations and handles
  /// any errors that may occur during the process.
  ///
  /// [onProgress] is an optional callback that will be called with the total
  /// number of stations and the number of stations downloaded so far.
  ///
  /// Throws a [RadioStationSyncFailure] if synchronization fails
  Future<void> execute({
    required void Function(int total, int downloaded) onProgress,
  }) async {
    try {
      await _radioStationRepository.syncStations(onProgress: onProgress);
    } catch (e) {
      log('Failed to sync radio stations: $e');
      throw RadioStationSyncFailure('Failed to sync radio stations: $e');
    }
  }
}
