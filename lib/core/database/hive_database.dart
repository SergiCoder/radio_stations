import 'package:hive_ce/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:radio_stations/features/radio/data/dto/radio_station_local_dto.dart';

/// Provides access to the Hive database throughout the app.
///
/// This class manages the initialization and access to the Hive database.
/// It handles the registration of adapters and opening of boxes.
class HiveDatabase {
  /// Private constructor to prevent instantiation
  HiveDatabase._();

  /// Initialize the database
  ///
  /// This method initializes Hive, registers adapters, and opens the necessary boxes.
  /// It should be called before any database operations are performed.
  static Future<Box<RadioStationLocalDto>> init() async {
    final appDir = await getApplicationDocumentsDirectory();

    // Initialize Hive
    Hive
      ..init(appDir.path)

      // Register adapters
      ..registerAdapter(RadioStationLocalDtoAdapter());

    try {
      // Open boxes
      final radioStationBox = await Hive.openBox<RadioStationLocalDto>(
        'radio_stations',
      );

      return radioStationBox;
    } catch (e) {
      if (e is HiveError || e is RangeError) {
        await Hive.deleteBoxFromDisk('radio_stations', path: appDir.path);
        final radioStationBox = await Hive.openBox<RadioStationLocalDto>(
          'radio_stations',
        );

        return radioStationBox;
      }

      rethrow;
    }
  }

  /// Closes the database
  ///
  /// This method should be called when the app is shutting down to properly
  /// close the database connection.
  static Future<void> close() async {
    await Hive.close();
  }
}
