import 'package:radio_stations/features/radio/domain/entities/radio_station.dart';

/// Extension methods for lists of [RadioStation]
extension RadioStationListExtension on List<RadioStation> {
  /// Returns a new list ordered by station name
  ///
  /// The ordering is case-insensitive and uses natural string comparison.
  /// Returns a new list without modifying the original.
  List<RadioStation> orderByName() {
    return [...this]
      ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
  }
}
