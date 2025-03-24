import 'package:flutter/foundation.dart';
import 'package:radio_stations/features/radio/domain/domain.dart';
import 'package:radio_stations/features/radio/domain/entities/sync_progress.dart';

/// Base class for the radio page state
///
/// This is the parent class for all states of the radio page.
@immutable
sealed class RadioPageState {
  /// Creates a new instance of [RadioPageState]
  const RadioPageState();

  /// List of properties used for equality comparison
  List<Object?> get props => [];

  /// Equality operator
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is RadioPageState &&
        runtimeType == other.runtimeType &&
        listEquals(props, other.props);
  }

  /// Hash code
  @override
  int get hashCode => Object.hash(runtimeType, Object.hashAll(props));
}

/// Error state for the radio page
///
/// This state is active when an error occurs while loading stations.
@immutable
class RadioPageErrorState extends RadioPageState {
  /// Creates a new instance of [RadioPageErrorState]
  ///
  /// [errorMessage] is the error message to display
  const RadioPageErrorState({required this.errorMessage});

  /// The error message to display
  final String errorMessage;

  @override
  List<Object?> get props => [errorMessage];
}

/// Loaded state for the radio page
///
/// This state is active when stations are successfully loaded.
@immutable
class RadioPageLoadedState extends RadioPageState {
  /// Creates a new instance of [RadioPageLoadedState]
  ///
  /// [stations] is the list of loaded stations
  /// [selectedStation] is the currently selected station, if any
  /// [selectedFilter] is the currently selected filter, if any
  /// [isPlaying] indicates whether the current station is playing
  /// [countries] is the list of available countries
  /// [volume] is the current volume level between 0.0 and 1.0
  const RadioPageLoadedState({
    required this.stations,
    this.selectedFilter,
    this.selectedStation,
    this.isPlaying = false,
    this.countries = const [],
    this.volume = 1.0,
  });

  /// The list of loaded stations
  final List<RadioStation> stations;

  /// The currently selected station, if any
  final RadioStation? selectedStation;

  /// The currently selected filter, if any
  final RadioStationFilter? selectedFilter;

  /// Whether the current station is playing
  final bool isPlaying;

  /// The list of available countries
  final List<String> countries;

  /// The current volume level between 0.0 and 1.0
  final double volume;

  /// Creates a copy of this state with the given fields replaced with new
  /// values
  RadioPageLoadedState copyWith({
    List<RadioStation>? stations,
    RadioStation? selectedStation,
    RadioStationFilter? selectedFilter,
    bool? isPlaying,
    List<String>? countries,
    String? selectedCountry,
    double? volume,
    bool clearSelectedStation = false,
  }) {
    return RadioPageLoadedState(
      stations: stations ?? this.stations,
      selectedStation:
          clearSelectedStation ? null : selectedStation ?? this.selectedStation,
      selectedFilter: selectedFilter ?? this.selectedFilter,
      isPlaying: isPlaying ?? this.isPlaying,
      countries: countries ?? this.countries,
      volume: volume ?? this.volume,
    );
  }

  @override
  List<Object?> get props => [
    stations,
    selectedStation,
    selectedFilter,
    isPlaying,
    countries,
    volume,
  ];
}

/// Sync progress state for the radio page
///
/// This state is active when stations are being synchronized from the remote source.
@immutable
final class RadioPageSyncProgressState extends RadioPageState {
  /// Creates a new instance of [RadioPageSyncProgressState]
  ///
  /// [totalStations] is the total number of stations to sync
  /// [downloadedStations] is the number of stations downloaded so far
  const RadioPageSyncProgressState({
    required this.totalStations,
    required this.downloadedStations,
  }) : assert(totalStations >= 0, 'Total stations must be non-negative'),
       assert(
         downloadedStations >= 0,
         'Downloaded stations must be non-negative',
       );

  /// The total number of stations to sync
  final int totalStations;

  /// The number of stations downloaded so far
  final int downloadedStations;

  /// The current progress percentage (0-100)
  double get progressPercentage =>
      totalStations > 0 ? (downloadedStations / totalStations) * 100 : 0;

  /// The sync progress
  SyncProgress get syncProgress => SyncProgress(
    totalStations: totalStations,
    downloadedStations: downloadedStations,
  );

  @override
  List<Object?> get props => [totalStations, downloadedStations];
}
