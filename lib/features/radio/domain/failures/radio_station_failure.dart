/// Base class for radio station failures
abstract class RadioStationFailure implements Exception {
  /// Creates a new [RadioStationFailure]
  ///
  /// [message] describes the failure that occurred
  const RadioStationFailure(this.message);

  /// The failure message
  final String message;

  @override
  String toString() => message;
}

/// Failure when it's not possible to sync radio stations
class RadioStationSyncFailure extends RadioStationFailure {
  /// Creates a new [RadioStationSyncFailure]
  ///
  /// [message] describes why the sync failed
  const RadioStationSyncFailure(super.message);
}

/// Failure when it's not possible to get radio station data
class RadioStationDataFailure extends RadioStationFailure {
  /// Creates a new [RadioStationDataFailure]
  ///
  /// [message] describes why the data retrieval failed
  const RadioStationDataFailure(super.message);
}
