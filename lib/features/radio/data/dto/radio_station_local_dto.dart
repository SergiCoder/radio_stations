import 'package:hive_ce/hive.dart';

part 'radio_station_local_dto_adapter.dart';

/// Data transfer object for radio stations stored locally
///
/// This class represents a radio station as it is stored in the local database.
/// It contains all the necessary information to display and play a radio station.
class RadioStationLocalDto extends HiveObject {
  /// Creates a new instance of [RadioStationLocalDto]
  RadioStationLocalDto({
    required this.changeuuid,
    required this.name,
    required this.url,
    required this.homepage,
    required this.favicon,
    required this.country,
    this.isFavorite = false,
    this.broken = false,
  });

  /// The unique identifier for changes
  final String changeuuid;

  /// The name of the radio station
  final String name;

  /// The URL of the radio stream
  final String url;

  /// The URL of the station's website
  final String homepage;

  /// The URL of the station's favicon
  final String favicon;

  /// The country where the radio station is located
  final String country;

  /// Whether the station is marked as favorite
  final bool isFavorite;

  /// Whether the station is broken (stream is not working)
  final bool broken;

  /// Creates a copy of this [RadioStationLocalDto] with the given fields replaced
  RadioStationLocalDto copyWith({
    String? changeuuid,
    String? name,
    String? url,
    String? homepage,
    String? favicon,
    String? country,
    bool? isFavorite,
    bool? broken,
  }) {
    return RadioStationLocalDto(
      changeuuid: changeuuid ?? this.changeuuid,
      name: name ?? this.name,
      url: url ?? this.url,
      homepage: homepage ?? this.homepage,
      favicon: favicon ?? this.favicon,
      country: country ?? this.country,
      isFavorite: isFavorite ?? this.isFavorite,
      broken: broken ?? this.broken,
    );
  }
}
