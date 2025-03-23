import 'package:radio_stations/features/radio/domain/entities/sync_progress.dart';

/// A presentation model for sync progress
class SyncProgressModel {
  /// Creates a new instance of [SyncProgressModel]
  const SyncProgressModel({
    required this.progress,
  });

  /// Creates a [SyncProgressModel] from a [SyncProgress] entity
  factory SyncProgressModel.fromEntity(SyncProgress entity) {
    return SyncProgressModel(
      progress: entity,
    );
  }

  /// The underlying sync progress entity
  final SyncProgress progress;

  /// The progress message to display
  String get progressMessage =>
      '${progress.downloadedStations} of ${progress.totalStations} stations';

  /// The progress value for the progress bar
  double get progressValue => progress.progress;
}
