import 'dart:developer';
import 'package:radio_stations/features/radio/data/dto/radio_station_remote_dto.dart';

/// Extension methods for [RadioStationRemoteDto] lists
extension RadioStationRemoteDtoListExtension on List<RadioStationRemoteDto> {
  /// Removes HLS elements from the list and logs the discarded ones
  ///
  /// Returns a new list containing only non-HLS radio stations.
  /// Logs the number and details of discarded stations.
  List<RadioStationRemoteDto> removeHlsStations() {
    final nonHlsStations = <RadioStationRemoteDto>[];
    final discardedStations = <RadioStationRemoteDto>[];

    for (final station in this) {
      if (station.hls == 0) {
        nonHlsStations.add(station);
      } else {
        discardedStations.add(station);
      }
    }

    if (discardedStations.isNotEmpty) {
      log('Discarded ${discardedStations.length} HLS stations:\n');
    }

    return nonHlsStations;
  }
}
