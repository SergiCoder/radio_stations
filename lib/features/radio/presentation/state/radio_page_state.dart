import 'package:flutter/foundation.dart';
import 'package:radio_stations/features/radio/domain/domain.dart';

/// Base class for the radio page state
///
/// This is the parent class for all states of the radio page.
@immutable
abstract class RadioPageState {
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
class RadioPageLoadedState extends RadioPageState {
  /// Creates a new instance of [RadioPageLoadedState]
  ///
  /// [stations] is the list of loaded stations
  /// [selectedStation] is the currently selected station, if any
  /// [selectedFilter] is the currently selected filter, if any
  const RadioPageLoadedState({
    required this.stations,
    this.selectedFilter,
    this.selectedStation,
  });

  /// The list of loaded stations
  final List<RadioStation> stations;

  /// The currently selected station, if any
  final RadioStation? selectedStation;

  /// The currently selected filter, if any
  final RadioStationFilter? selectedFilter;

  /// Creates a copy of this state with the given fields replaced with new
  /// values
  RadioPageLoadedState copyWith({
    List<RadioStation>? stations,
    RadioStation? selectedStation,
    RadioStationFilter? selectedFilter,
    bool clearSelectedStation = false,
  }) {
    return RadioPageLoadedState(
      stations: stations ?? this.stations,
      selectedStation:
          clearSelectedStation ? null : selectedStation ?? this.selectedStation,
      selectedFilter: selectedFilter ?? this.selectedFilter,
    );
  }

  @override
  List<Object?> get props => [stations, selectedStation, selectedFilter];
}

/// Sync progress state for the radio page
///
/// This state is active when stations are being synchronized from the remote source.
class RadioPageSyncProgressState extends RadioPageState {
  /// Creates a new instance of [RadioPageSyncProgressState]
  ///
  /// [totalStations] is the total number of stations to sync
  /// [downloadedStations] is the number of stations downloaded so far
  const RadioPageSyncProgressState({
    required this.totalStations,
    required this.downloadedStations,
  });

  /// The total number of stations to sync
  final int totalStations;

  /// The number of stations downloaded so far
  final int downloadedStations;

  /// The current progress percentage (0-100)
  double get progressPercentage =>
      totalStations > 0 ? (downloadedStations / totalStations) * 100 : 0;

  @override
  List<Object?> get props => [totalStations, downloadedStations];
}
