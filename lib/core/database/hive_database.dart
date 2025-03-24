import 'package:hive_ce/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:radio_stations/features/radio/data/dto/radio_station_local_dto.dart';

/// Database interface for consistent access across implementations
///
/// This interface defines the core operations for database management,
/// allowing for different implementations to be swapped in as needed.
abstract class Database {
  /// Initialize the database and open necessary boxes
  ///
  /// Returns a [Box] containing radio station data.
  Future<Box<RadioStationLocalDto>> init();

  /// Closes the database connection
  ///
  /// This should be called when the database is no longer needed.
  Future<void> close();
}

/// Provides access to the Hive database throughout the app.
///
/// This class manages the initialization and access to the Hive database.
/// It handles the registration of adapters and opening of boxes.
class HiveDatabase implements Database {
  /// Private constructor to prevent direct instantiation
  ///
  /// Use [create] method to get a properly initialized instance.
  HiveDatabase._();

  /// Creates and initializes a new [HiveDatabase] instance
  ///
  /// This is the preferred way to create a database instance as it ensures
  /// proper initialization.
  ///
  /// Example:
  /// ```dart
  /// final database = await HiveDatabase.create();
  /// final box = await database.init();
  /// ```
  static Future<HiveDatabase> create() async {
    final database = HiveDatabase._();
    return database;
  }

  // For easier mocking in tests, we keep these as instance methods
  // but allow them to be overridden

  /// Gets the application documents directory
  ///
  /// This is overridable for testing purposes.
  Future<String> getApplicationPath() async {
    final appDir = await getApplicationDocumentsDirectory();
    return appDir.path;
  }

  /// Initializes Hive with the given path
  ///
  /// This is overridable for testing purposes.
  void initHive(String path) {
    Hive.init(path);
  }

  /// Registers Hive adapters
  ///
  /// This is overridable for testing purposes.
  void registerAdapters() {
    Hive.registerAdapter(RadioStationLocalDtoAdapter());
  }

  /// Opens a box with the given name
  ///
  /// This is overridable for testing purposes.
  Future<Box<T>> openBox<T>(String name) {
    return Hive.openBox<T>(name);
  }

  /// Delete a box from disk
  ///
  /// This is overridable for testing purposes.
  Future<void> deleteBoxFromDisk(String name, {required String path}) {
    return Hive.deleteBoxFromDisk(name, path: path);
  }

  /// Close all boxes
  ///
  /// This is overridable for testing purposes.
  Future<void> closeBoxes() {
    return Hive.close();
  }

  @override
  Future<Box<RadioStationLocalDto>> init() async {
    final appPath = await getApplicationPath();

    // Initialize Hive
    initHive(appPath);

    // Register adapters
    registerAdapters();

    try {
      // Open boxes
      final radioStationBox = await openBox<RadioStationLocalDto>(
        'radio_stations',
      );
      return radioStationBox;
    } catch (e) {
      if (e is HiveError || e is RangeError) {
        await deleteBoxFromDisk('radio_stations', path: appPath);
        final radioStationBox = await openBox<RadioStationLocalDto>(
          'radio_stations',
        );
        return radioStationBox;
      }

      rethrow;
    }
  }

  @override
  Future<void> close() async {
    await closeBoxes();
  }
}
