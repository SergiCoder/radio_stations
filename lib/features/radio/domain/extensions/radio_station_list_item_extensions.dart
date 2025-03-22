import 'package:radio_stations/features/radio/domain/entities/radio_station_list_item.dart';

/// Extension methods for lists of [RadioStationListItem]
extension RadioStationListItemListExtension on List<RadioStationListItem> {
  /// Returns a new list ordered by station name
  ///
  /// The ordering is case-insensitive and uses natural string comparison.
  /// Returns a new list without modifying the original.
  List<RadioStationListItem> orderByName() {
    return [...this]
      ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
  }

  /// Returns a new list ordered by station name in descending order
  ///
  /// The ordering is case-insensitive and uses natural string comparison.
  /// Returns a new list without modifying the original.
  List<RadioStationListItem> orderByNameDescending() {
    return [...this]
      ..sort((a, b) => b.name.toLowerCase().compareTo(a.name.toLowerCase()));
  }
}
