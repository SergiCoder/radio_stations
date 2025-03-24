import 'package:equatable/equatable.dart';
import 'package:radio_stations/features/radio/domain/domain.dart';
import 'package:radio_stations/features/shared/domain/entitites/radio_station.dart';

/// Base class for all radio page states.
///
/// This abstract class serves as the foundation for all possible states
/// in the Radio Page feature. Following the BLoC pattern, states are immutable
/// snapshots representing the UI at a specific point in time.
abstract class RadioPageState extends Equatable {
  /// Creates a new [RadioPageState] instance.
  const RadioPageState();

  @override
  List<Object?> get props => [];
}

/// Initial state before any content is loaded.
///
/// This is the default state when the Radio Page is first created.
/// It represents the state before any radio stations are loaded
/// or any user interactions have occurred.
class RadioPageInitial extends RadioPageState {
  /// Creates a new [RadioPageInitial] state.
  const RadioPageInitial();
}

/// State during synchronization with remote data source.
///
/// This state is active while the application is fetching radio stations
/// from the remote API. It provides progress information about the ongoing
/// synchronization process.
class RadioPageSyncProgress extends RadioPageState {
  /// Creates a new [RadioPageSyncProgress] state.
  ///
  /// [totalStations] is the total number of stations to download.
  /// [downloadedStations] is the number of stations downloaded so far.
  const RadioPageSyncProgress({
    required this.totalStations,
    required this.downloadedStations,
  });

  /// Total number of stations to synchronize.
  ///
  /// Represents the total count of radio stations that will be downloaded
  /// during the current synchronization operation.
  final int totalStations;

  /// Number of stations successfully downloaded so far.
  ///
  /// Represents the current progress of the synchronization process.
  /// This value increases as stations are downloaded and should never
  /// exceed [totalStations].
  final int downloadedStations;

  /// Computes the download progress as a percentage (0.0 to 1.0).
  ///
  /// Returns 0.0 if totalStations is 0 to avoid division by zero.
  double get progressPercentage =>
      totalStations > 0 ? downloadedStations / totalStations : 0.0;

  @override
  List<Object> get props => [totalStations, downloadedStations];
}

/// State when stations are successfully loaded and ready for display.
///
/// This state represents the main content state of the Radio Page when
/// stations have been loaded and are available for browsing and playback.
/// It contains all data needed to render the UI, including the list of
/// stations, currently selected station, and playback state.
class RadioPageLoaded extends RadioPageState {
  /// Creates a new [RadioPageLoaded] state.
  ///
  /// [stations] is the list of radio stations filtered by current criteria.
  /// [selectedStation] is the currently selected radio station, if any.
  /// [countries] is the list of available countries for filtering.
  /// [selectedFilter] is the current filter settings.
  /// [isPlaying] indicates whether audio is currently playing.
  /// [volume] is the current volume level (0.0 to 1.0).
  const RadioPageLoaded({
    required this.stations,
    required this.countries,
    required this.selectedFilter,
    required this.isPlaying,
    required this.volume,
    this.selectedStation,
  });

  /// List of radio stations filtered by current criteria.
  ///
  /// These are the stations currently visible to the user,
  /// after applying any filters like favorites or country selection.
  final List<RadioStation> stations;

  /// Currently selected radio station, if any.
  ///
  /// This is the station that is currently featured in the player.
  /// It may be playing or paused depending on [isPlaying].
  /// Can be null if no station is selected.
  final RadioStation? selectedStation;

  /// List of available countries for filtering.
  ///
  /// These are the countries that have at least one station available,
  /// used to populate the country filter dropdown.
  final List<String> countries;

  /// Current filter settings applied to the stations list.
  ///
  /// Contains filtering criteria such as whether to show only favorites
  /// and which country to filter by.
  final RadioStationFilter selectedFilter;

  /// Whether audio is currently playing.
  ///
  /// True if a station is actively playing audio.
  /// False if playback is paused or no station is selected.
  final bool isPlaying;

  /// Current volume level.
  ///
  /// Ranges from 0.0 (silent) to 1.0 (maximum volume).
  final double volume;

  /// Creates a copy of the current state with specified fields updated.
  ///
  /// This method allows for creating a new state with only specific
  /// properties changed, following the immutability pattern.
  ///
  /// [stations] updates the list of radio stations.
  /// [selectedStation] updates the currently selected station.
  /// [clearSelectedStation] when true, sets selectedStation to null.
  /// [countries] updates the list of available countries.
  /// [selectedFilter] updates the current filter settings.
  /// [isPlaying] updates the playback state.
  /// [volume] updates the volume level.
  ///
  /// Returns a new [RadioPageLoaded] instance with the updated values.
  RadioPageLoaded copyWith({
    List<RadioStation>? stations,
    RadioStation? selectedStation,
    bool clearSelectedStation = false,
    List<String>? countries,
    RadioStationFilter? selectedFilter,
    bool? isPlaying,
    double? volume,
  }) {
    return RadioPageLoaded(
      stations: stations ?? this.stations,
      selectedStation:
          clearSelectedStation
              ? null
              : (selectedStation ?? this.selectedStation),
      countries: countries ?? this.countries,
      selectedFilter: selectedFilter ?? this.selectedFilter,
      isPlaying: isPlaying ?? this.isPlaying,
      volume: volume ?? this.volume,
    );
  }

  /// Checks if there are any favorite stations.
  ///
  /// Returns true if at least one station is marked as favorite.
  bool get hasFavorites => stations.any((station) => station.isFavorite);

  @override
  List<Object?> get props => [
    stations,
    selectedStation,
    countries,
    selectedFilter,
    isPlaying,
    volume,
  ];
}

/// State when an error occurs during loading or playback.
///
/// This state represents an error condition in the Radio Page.
/// It provides an error message for display to the user and optionally
/// preserves the previous state for recovery after the error is addressed.
class RadioPageError extends RadioPageState {
  /// Creates a new [RadioPageError] state.
  ///
  /// [errorMessage] is the error message to display to the user.
  /// [previousState] is the state before the error occurred, if available.
  const RadioPageError({required this.errorMessage, this.previousState});

  /// Error message to display to the user.
  ///
  /// A human-readable description of what went wrong.
  /// This should be suitable for displaying directly in the UI.
  final String errorMessage;

  /// Previous state before the error occurred, if available.
  ///
  /// This allows the application to potentially recover and return
  /// to the previous state once the error is addressed.
  /// May be null if the error occurred during initial loading.
  final RadioPageState? previousState;

  /// Indicates whether recovery to a previous state is possible.
  ///
  /// Returns true if [previousState] is not null and is a [RadioPageLoaded] state.
  bool get canRecover => previousState is RadioPageLoaded;

  @override
  List<Object?> get props => [errorMessage, previousState];
}
