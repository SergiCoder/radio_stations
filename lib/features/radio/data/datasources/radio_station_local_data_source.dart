import 'package:hive_ce/hive.dart';
import 'package:radio_stations/features/radio/data/dto/radio_station_local_dto.dart';
import 'package:radio_stations/features/shared/domain/entitites/radio_station.dart';

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
  /// [station] is the station to toggle the favorite status for
  Future<void> toggleStationFavorite(RadioStation station) async {
    final stationDto = box.get(station.uuid);
    final updatedStation = stationDto!.copyWith(
      isFavorite: !station.isFavorite,
    );
    await box.put(station.uuid, updatedStation);
  }

  /// Toggles the broken status of a station
  ///
  /// [station] is the station to toggle the broken status for
  Future<void> toggleStationBroken(RadioStation station) async {
    final stationDto = box.get(station.uuid);
    final updatedStation = stationDto!.copyWith(broken: !station.broken);
    await box.put(station.uuid, updatedStation);
  }
}
