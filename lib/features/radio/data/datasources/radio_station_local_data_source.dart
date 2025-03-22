import 'package:hive_ce/hive.dart';
import 'package:radio_stations/features/radio/data/dto/radio_station_local_dto.dart';

/// Local data source for radio stations
///
/// This class handles all local storage operations for radio stations using Hive.
class RadioStationLocalDataSource {
  /// Creates a new instance of [RadioStationLocalDataSource]
  ///
  /// The [box] parameter is the Hive box that stores the radio stations.
  RadioStationLocalDataSource({required this.box});

  /// The Hive box that stores the radio stations
  final Box<RadioStationLocalDto> box;

  /// Gets all radio stations from local storage
  ///
  /// Returns a list of [RadioStationLocalDto] objects.
  List<RadioStationLocalDto> getAllStations() {
    return box.values.toList();
  }

  /// Gets a radio station by its change UUID from local storage
  ///
  /// The [changeuuid] parameter is the unique identifier for changes.
  /// Returns the [RadioStationLocalDto] if found, null otherwise.
  RadioStationLocalDto? getStationById(String changeuuid) {
    return box.get(changeuuid);
  }

  /// Saves a radio station to local storage
  ///
  /// The [station] parameter is the [RadioStationLocalDto] to save.
  Future<void> saveStation(RadioStationLocalDto station) async {
    await box.put(station.changeuuid, station);
  }

  /// Saves multiple radio stations to local storage
  ///
  /// The [stations] parameter is a list of [RadioStationLocalDto] objects to save.
  Future<void> saveStations(List<RadioStationLocalDto> stations) async {
    final map = <String, RadioStationLocalDto>{
      for (final station in stations) station.changeuuid: station,
    };
    await box.putAll(map);
  }

  /// Deletes all radio stations from local storage
  Future<void> deleteAllStations() async {
    await box.clear();
  }

  /// Toggles the favorite status of a station
  ///
  /// [stationId] is the ID of the station to toggle the favorite status for
  Future<void> toggleStationFavorite(String stationId) async {
    final station = getStationById(stationId);
    if (station != null) {
      final updatedStation = station.copyWith(isFavorite: !station.isFavorite);
      await box.put(stationId, updatedStation);
    }
  }

  /// Toggles the broken status of a station
  ///
  /// [stationId] is the ID of the station to toggle the broken status for
  Future<void> toggleStationBroken(String stationId) async {
    final station = getStationById(stationId);
    if (station != null) {
      final updatedStation = station.copyWith(broken: !station.broken);
      await box.put(stationId, updatedStation);
    }
  }
}
