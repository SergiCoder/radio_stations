/// Represents the progress of a synchronization operation
class SyncProgress {
  /// Creates a new instance of [SyncProgress]
  const SyncProgress({
    required this.totalStations,
    required this.downloadedStations,
  })  : assert(totalStations >= 0, 'totalStations must be non-negative'),
        assert(
          downloadedStations >= 0,
          'downloadedStations must be non-negative',
        ),
        assert(
          downloadedStations <= totalStations,
          'downloadedStations must not exceed totalStations',
        );

  /// The total number of stations to download
  final int totalStations;

  /// The number of stations downloaded so far
  final int downloadedStations;

  /// The progress as a value between 0 and 1
  double get progress =>
      totalStations > 0 ? downloadedStations / totalStations : 0.0;

  /// Whether the sync is complete
  bool get isComplete => downloadedStations >= totalStations;
}
