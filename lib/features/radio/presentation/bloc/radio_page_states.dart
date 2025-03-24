import 'package:radio_stations/features/radio/domain/domain.dart';

/// Base class for all radio page states
abstract class RadioPageState {
  const RadioPageState();
}

/// Initial state before any loading occurs
class RadioPageInitial extends RadioPageState {
  const RadioPageInitial();
}

/// State during synchronization with remote source
class RadioPageSyncProgress extends RadioPageState {
  /// Total number of stations to sync
  final int totalStations;

  /// Number of stations downloaded so far
  final int downloadedStations;

  const RadioPageSyncProgress({
    required this.totalStations,
    required this.downloadedStations,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is RadioPageSyncProgress &&
        other.totalStations == totalStations &&
        other.downloadedStations == downloadedStations;
  }

  @override
  int get hashCode => totalStations.hashCode ^ downloadedStations.hashCode;
}

/// State when stations are loaded
class RadioPageLoaded extends RadioPageState {
  /// List of radio stations filtered by current criteria
  final List<RadioStation> stations;

  /// Currently selected radio station
  final RadioStation? selectedStation;

  /// List of available countries for filtering
  final List<String> countries;

  /// Current filter settings
  final RadioStationFilter selectedFilter;

  /// Whether audio is currently playing
  final bool isPlaying;

  /// Current volume level (0.0 to 1.0)
  final double volume;

  const RadioPageLoaded({
    required this.stations,
    this.selectedStation,
    required this.countries,
    required this.selectedFilter,
    required this.isPlaying,
    required this.volume,
  });

  /// Creates a copy of the current state with specified fields updated
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

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is RadioPageLoaded &&
        _listEquals(other.stations, stations) &&
        other.selectedStation == selectedStation &&
        _listEquals(other.countries, countries) &&
        other.selectedFilter == selectedFilter &&
        other.isPlaying == isPlaying &&
        other.volume == volume;
  }

  @override
  int get hashCode => Object.hash(
    Object.hashAll(stations),
    selectedStation,
    Object.hashAll(countries),
    selectedFilter,
    isPlaying,
    volume,
  );

  // Helper method for list comparison
  bool _listEquals<T>(List<T>? a, List<T>? b) {
    if (a == null) return b == null;
    if (b == null || a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}

/// State when an error occurs
class RadioPageError extends RadioPageState {
  /// Error message to display
  final String errorMessage;

  /// Previous state before the error (if available)
  final RadioPageState? previousState;

  const RadioPageError({required this.errorMessage, this.previousState});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is RadioPageError &&
        other.errorMessage == errorMessage &&
        other.previousState == previousState;
  }

  @override
  int get hashCode => errorMessage.hashCode ^ previousState.hashCode;
}
