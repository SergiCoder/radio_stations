import 'dart:async';
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:radio_stations/features/audio/domain/usecases/get_volume_stream_use_case.dart';
import 'package:radio_stations/features/radio/domain/domain.dart';
import 'package:radio_stations/features/radio/domain/use_cases/set_volume_use_case.dart';
import 'package:radio_stations/features/radio/domain/use_cases/toggle_favorite_radio_station_use_case.dart';
import 'package:radio_stations/features/radio/presentation/state/radio_page_state.dart';
import 'package:radio_stations/features/radio/presentation/widgets/pages/radio_page.dart';
import 'package:radio_stations/features/shared/domain/events/error_event_bus.dart';

/// Cubit that manages the state of the [RadioPage]
///
/// This cubit is responsible for loading radio stations and handling
/// user interactions with the radio page. It provides functionality for:
/// 1. Loading and syncing radio stations
/// 2. Filtering stations by country and favorites
/// 3. Controlling playback (play, pause, next, previous)
/// 4. Managing favorites and volume
/// 5. Handling errors and state updates
class RadioPageCubit extends Cubit<RadioPageState> {
  /// Creates a new instance of [RadioPageCubit]
  ///
  /// This constructor initializes the cubit with all required dependencies
  /// and sets up the initial state.
  ///
  /// Parameters:
  /// - [getRadioStationListUseCase]: Used to fetch all radio stations from the local data source
  /// - [syncStationsUseCase]: Used to synchronize radio stations with a remote source
  /// - [playRadioStationUseCase]: Used to play a selected radio station
  /// - [toggleFavoriteUseCase]: Used to toggle the favorite status of a station
  /// - [getPlaybackStateUseCase]: Used to get the current playback state (playing/paused)
  /// - [togglePlayPauseUseCase]: Used to toggle between play and pause states
  /// - [setBrokenRadioStationUseCase]: Used to mark a station as broken/non-functional
  /// - [setVolumeUseCase]: Used to control the audio volume
  /// - [getVolumeStreamUseCase]: Used to get a stream of volume changes
  /// - [errorEventBus]: Used to listen to error events across the application
  ///
  /// The initial state is set to [RadioPageSyncProgressState] with zero stations.
  RadioPageCubit({
    required GetRadioStationListUseCase getRadioStationListUseCase,
    required SyncRadioStationsUseCase syncStationsUseCase,
    required PlayRadioStationUseCase playRadioStationUseCase,
    required ToggleFavoriteRadioStationUseCase toggleFavoriteUseCase,
    required GetPlaybackStateUseCase getPlaybackStateUseCase,
    required TogglePlayPauseUseCase togglePlayPauseUseCase,
    required SetBrokenRadioStationUseCase setBrokenRadioStationUseCase,
    required SetVolumeUseCase setVolumeUseCase,
    required GetVolumeStreamUseCase getVolumeStreamUseCase,
    required ErrorEventBus errorEventBus,
  }) : _getRadioStationListUseCase = getRadioStationListUseCase,
       _syncStationsUseCase = syncStationsUseCase,
       _playRadioStationUseCase = playRadioStationUseCase,
       _toggleFavoriteUseCase = toggleFavoriteUseCase,
       _getPlaybackStateUseCase = getPlaybackStateUseCase,
       _togglePlayPauseUseCase = togglePlayPauseUseCase,
       _setBrokenRadioStationUseCase = setBrokenRadioStationUseCase,
       _setVolumeUseCase = setVolumeUseCase,
       _getVolumeStreamUseCase = getVolumeStreamUseCase,
       _errorEventBus = errorEventBus,
       super(
         const RadioPageSyncProgressState(
           totalStations: 0,
           downloadedStations: 0,
         ),
       );

  /// Event bus for error events
  ///
  /// This bus provides a stream of error events related to radio stations
  /// that can be listened to across the application.
  final ErrorEventBus _errorEventBus;

  /// The use case for getting all radio stations
  ///
  /// Provides access to the local repository of radio stations with
  /// filtering capabilities.
  final GetRadioStationListUseCase _getRadioStationListUseCase;

  /// The use case for synchronizing radio stations with a remote source
  ///
  /// Handles fetching the latest radio station data from the remote API
  /// and updating the local cache.
  final SyncRadioStationsUseCase _syncStationsUseCase;

  /// The use case for playing a radio station
  ///
  /// Manages the audio playback of a selected radio station.
  final PlayRadioStationUseCase _playRadioStationUseCase;

  /// The use case for toggling the favorite status of a station
  ///
  /// Handles marking/unmarking a station as a favorite in the local database.
  final ToggleFavoriteRadioStationUseCase _toggleFavoriteUseCase;

  /// The use case for getting the current playback state
  ///
  /// Provides a stream of playback state changes (playing/paused).
  final GetPlaybackStateUseCase _getPlaybackStateUseCase;

  /// The use case for toggling play/pause
  ///
  /// Controls the playback state of the currently selected station.
  final TogglePlayPauseUseCase _togglePlayPauseUseCase;

  /// The use case for setting a radio station as broken
  ///
  /// Marks a station as non-functional in the local database.
  final SetBrokenRadioStationUseCase _setBrokenRadioStationUseCase;

  /// The use case for controlling audio volume
  ///
  /// Adjusts the volume level of the audio playback.
  final SetVolumeUseCase _setVolumeUseCase;

  /// The use case for getting volume changes
  ///
  /// Provides a stream of volume level changes.
  final GetVolumeStreamUseCase _getVolumeStreamUseCase;

  /// Subscription to error events
  ///
  /// Tracks the active subscription to the error event stream
  /// for proper cleanup.
  StreamSubscription<RadioStation>? _errorSubscription;

  /// Subscription to playback state changes
  ///
  /// Tracks the active subscription to the playback state stream
  /// for proper cleanup.
  StreamSubscription<bool>? _playbackSubscription;

  /// Subscription to volume changes
  ///
  /// Tracks the active subscription to the volume changes stream
  /// for proper cleanup.
  StreamSubscription<double>? _volumeSubscription;

  /// Initializes the cubit and loads the stations
  ///
  /// This method should be called right after creating the cubit.
  /// It loads stations from the local database, sets up event listeners for
  /// playback state changes, error events, and volume changes.
  /// If an error occurs during initialization, it will be handled by the
  /// [_handleAndEmitError] method.
  Future<void> init() async {
    try {
      await loadStations();
      _listenToPlaybackState();
      _listenToErrorEvents();
      _listenToVolumeChanges();
    } catch (e) {
      _handleAndEmitError(e);
    }
  }

  /// Closes the cubit and cancels all subscriptions
  ///
  /// This method performs cleanup when the cubit is no longer needed:
  /// 1. Cancels all event subscriptions to prevent memory leaks
  /// 2. Calls the parent class close method
  ///
  /// Errors during cleanup are logged but not propagated, as this is a
  /// non-critical operation that shouldn't affect the user experience.
  @override
  Future<void> close() async {
    try {
      await _errorSubscription?.cancel();
      await _playbackSubscription?.cancel();
      await _volumeSubscription?.cancel();
      await super.close();
    } catch (e) {
      // Log error but don't rethrow as this is cleanup
      log('Error closing cubit: $e');
    }
  }

  /// Listens to error events from the error event bus and updates the stations list
  /// when an error occurs.
  ///
  /// This method sets up a subscription to the error event bus and when a station
  /// is reported as having an error:
  /// 1. Finds the station in the current list
  /// 2. Marks it as broken
  /// 3. Updates the UI with the new list
  /// 4. Persists the broken state via the [_setBrokenRadioStationUseCase]
  ///
  /// Any errors in the subscription are handled via [_handleAndEmitError].
  void _listenToErrorEvents() {
    _errorSubscription = _errorEventBus.stream.listen(
      (station) {
        if (state is RadioPageLoadedState) {
          final loadedState = state as RadioPageLoadedState;
          final stations =
              loadedState.stations
                  .map(
                    (s) =>
                        s.uuid == station.uuid
                            ? station.copyWith(broken: true)
                            : s,
                  )
                  .toList();
          emit(loadedState.copyWith(stations: stations));
          _setBrokenRadioStationUseCase.execute(station);
        }
      },
      // due to formatter error
      // ignore: require_trailing_commas
      onError: _handleAndEmitError,
    );
  }

  /// Listens to playback state changes and updates the UI accordingly
  ///
  /// This method sets up a subscription to the playback state stream and:
  /// 1. Receives updates about whether audio is playing or paused
  /// 2. Updates the state with the new playing status
  /// 3. Causes the UI to reflect the current playback state
  ///
  /// Any errors in the subscription are handled via [_handleAndEmitError].
  void _listenToPlaybackState() {
    _playbackSubscription = _getPlaybackStateUseCase.playingStateStream.listen(
      (isPlaying) {
        if (state is RadioPageLoadedState) {
          final loadedState = state as RadioPageLoadedState;
          emit(loadedState.copyWith(isPlaying: isPlaying));
        }
      },
      // due to formatter error
      // ignore: require_trailing_commas
      onError: _handleAndEmitError,
    );
  }

  /// Listens to volume changes and updates the UI accordingly
  ///
  /// This method sets up a subscription to the volume stream and:
  /// 1. Receives updates when the audio volume changes
  /// 2. Updates the state with the new volume level
  /// 3. Causes the UI to reflect the current volume
  ///
  /// Any errors in the subscription are handled via [_handleAndEmitError].
  void _listenToVolumeChanges() {
    _volumeSubscription = _getVolumeStreamUseCase().listen(
      (volume) {
        if (state is RadioPageLoadedState) {
          final loadedState = state as RadioPageLoadedState;
          emit(loadedState.copyWith(volume: volume));
        }
      },
      // due to formatter error
      // ignore: require_trailing_commas
      onError: _handleAndEmitError,
    );
  }

  /// Loads radio stations from the local data source
  ///
  /// This method:
  /// 1. Preserves the last loaded state if available
  /// 2. Optionally syncs with remote source if [forceSync] is true or if there
  ///    are no stations locally
  /// 3. Loads stations from local cache using the current filter
  /// 4. Updates available countries for filtering
  /// 5. Emits a new loaded state with all current data
  ///
  /// Parameters:
  /// - [forceSync]: When true, forces synchronization with the remote source
  ///   regardless of local cache status
  ///
  /// Any errors during loading are handled via [_handleAndEmitError].
  Future<void> loadStations({bool forceSync = false}) async {
    try {
      final isLoadedState = state is RadioPageLoadedState;
      final lastLoadedState =
          isLoadedState ? state as RadioPageLoadedState : null;

      if (forceSync) {
        await _syncStations();
      }

      final filter =
          isLoadedState
              ? lastLoadedState!.selectedFilter
              : const RadioStationFilter(favorite: false);
      // First try to get stations from local cache
      final stations = await _getRadioStationListUseCase.execute(filter);

      // If we have no stations and forceSync is false
      if (stations.isEmpty && !forceSync) {
        await _syncStations();
        stations.addAll(await _getRadioStationListUseCase.execute(filter));
      }

      // Update available countries and languages
      final countries =
          await _getRadioStationListUseCase.getAvailableCountries();

      emit(
        RadioPageLoadedState(
          stations: stations,
          selectedStation: lastLoadedState?.selectedStation,
          countries: countries,
          selectedFilter:
              lastLoadedState?.selectedFilter ??
              const RadioStationFilter(favorite: false),
          isPlaying: lastLoadedState?.isPlaying ?? false,
          volume: lastLoadedState?.volume ?? 1.0,
        ),
      );
    } catch (e) {
      _handleAndEmitError(e);
    }
  }

  /// Synchronizes radio stations with the remote source
  ///
  /// This method:
  /// 1. Emits a sync progress state to show a loading indicator
  /// 2. Fetches stations from the remote source using [_syncStationsUseCase]
  /// 3. Updates the sync progress as stations are downloaded via an onProgress callback
  /// 4. Updates the local cache with the fetched stations
  ///
  /// The onProgress callback passed to _syncStationsUseCase.execute()
  /// updates the UI with download progress information.
  /// Any errors during synchronization are handled via [_handleAndEmitError].
  Future<void> _syncStations() async {
    try {
      emit(
        const RadioPageSyncProgressState(
          totalStations: 0,
          downloadedStations: 0,
        ),
      );
      await _syncStationsUseCase.execute(
        onProgress: (total, downloaded) {
          try {
            // Ensure downloaded never exceeds total
            final validDownloaded = downloaded > total ? total : downloaded;
            emit(
              RadioPageSyncProgressState(
                totalStations: total,
                downloadedStations: validDownloaded,
              ),
            );
          } catch (e) {
            _handleAndEmitError(e);
          }
        },
      );
    } catch (e) {
      _handleAndEmitError(e);
    }
  }

  /// Handles toggling the favorite filter
  ///
  /// This method:
  /// 1. Gets the current filter state
  /// 2. Toggles the favorite filter on/off
  /// 3. Fetches stations matching the new filter
  /// 4. Emits a new state with updated stations and filter
  ///
  /// When the favorite filter is on, only stations marked as favorites will be displayed.
  /// When it's off, all stations (subject to other filters) will be shown.
  ///
  /// Any errors during the operation are handled via [_handleAndEmitError].
  Future<void> toggleFavorites() async {
    final loadedState = _getLoadedState();
    if (loadedState == null) return;

    try {
      final currentFilter = loadedState.selectedFilter;
      final filter = currentFilter.toggleFavorite();
      final stations = await _getRadioStationListUseCase.execute(filter);

      emit(
        loadedState.copyWith(
          stations: stations,
          selectedStation: loadedState.selectedStation,
          selectedFilter: filter,
          isPlaying: loadedState.isPlaying,
          volume: loadedState.volume,
        ),
      );
    } catch (e) {
      _handleAndEmitError(e);
    }
  }

  /// Sets the selected country and updates the stations list
  ///
  /// This method:
  /// 1. Updates the filter with the new country selection
  /// 2. Fetches stations for the selected country
  /// 3. Emits a new state with updated stations and filter
  ///
  /// Parameters:
  /// - [country]: The country code to filter by. If null, the country filter
  ///   will be removed, showing stations from all countries.
  ///
  /// Any errors during the operation are handled via [_handleAndEmitError].
  Future<void> setSelectedCountry(String? country) async {
    final loadedState = _getLoadedState();
    if (loadedState == null) return;

    try {
      final currentFilter = loadedState.selectedFilter;
      final filter =
          country == null
              ? currentFilter.withoutCountry()
              : currentFilter.withCountry(country);
      final stations = await _getRadioStationListUseCase.execute(filter);

      emit(
        loadedState.copyWith(
          stations: stations,
          selectedFilter: filter,
          selectedStation: loadedState.selectedStation,
          isPlaying: loadedState.isPlaying,
          volume: loadedState.volume,
        ),
      );
    } catch (e) {
      _handleAndEmitError(e);
    }
  }

  /// Handles the selection of a radio station
  ///
  /// This method:
  /// 1. Updates the state with the newly selected station
  /// 2. Initiates playback of the selected station
  ///
  /// If the same station is already selected, this method does nothing.
  ///
  /// Parameters:
  /// - [station]: The radio station to select and play
  ///
  /// Any errors during the operation are handled via [_handleAndEmitError].
  Future<void> selectStation(RadioStation station) async {
    final loadedState = _getLoadedState();
    if (loadedState == null) return;

    // If the same station is selected, do nothing
    if (loadedState.selectedStation?.uuid == station.uuid) {
      return;
    }
    emit(loadedState.copyWith(selectedStation: station));

    try {
      await _playRadioStationUseCase.execute(station);
    } catch (e) {
      _handleAndEmitError(e);
    }
  }

  /// Handles play/pause for the current station
  ///
  /// This method toggles playback state of the currently selected station:
  /// 1. If currently playing, it will pause
  /// 2. If currently paused, it will resume playing
  ///
  /// If no station is currently selected, this method does nothing.
  ///
  /// Any errors during the operation are handled via [_handleAndEmitError].
  Future<void> togglePlayPause() async {
    final loadedState = _getLoadedState();
    if (loadedState == null) return;
    if (loadedState.selectedStation == null) return;

    try {
      await _togglePlayPauseUseCase.execute();
    } catch (e) {
      _handleAndEmitError(e);
    }
  }

  /// Handles skipping to the next station
  ///
  /// This method:
  /// 1. Finds the currently selected station in the filtered list
  /// 2. Determines the next station (cycling to the first if at the end)
  /// 3. Selects and plays the next station
  ///
  /// If the current station isn't in the filtered list (due to filter changes),
  /// it will start from the first station in the list.
  ///
  /// If the stations list is empty, this method does nothing.
  ///
  /// Any errors during the operation are handled via [_handleAndEmitError].
  Future<void> nextStation() async {
    final loadedState = _getLoadedState();
    if (loadedState == null) return;

    final currentStation = loadedState.selectedStation;
    final stations = loadedState.stations;

    if (stations.isEmpty) return;

    try {
      // If current station is not in the filtered list, start from the first station
      if (currentStation == null || !stations.contains(currentStation)) {
        await selectStation(stations.first);
        return;
      }

      final currentIndex = stations.indexOf(currentStation);
      final nextIndex = (currentIndex + 1) % stations.length;
      final nextStation = stations[nextIndex];

      await selectStation(nextStation);
    } catch (e) {
      _handleAndEmitError(e);
    }
  }

  /// Handles skipping to the previous station
  ///
  /// This method:
  /// 1. Finds the currently selected station in the filtered list
  /// 2. Determines the previous station (cycling to the last if at the beginning)
  /// 3. Selects and plays the previous station
  ///
  /// If the current station isn't in the filtered list (due to filter changes),
  /// it will start from the last station in the list.
  ///
  /// If the stations list is empty, this method does nothing.
  ///
  /// Any errors during the operation are handled via [_handleAndEmitError].
  Future<void> previousStation() async {
    final loadedState = _getLoadedState();
    if (loadedState == null) return;

    final currentStation = loadedState.selectedStation;
    final stations = loadedState.stations;

    if (stations.isEmpty) return;

    try {
      // If current station is not in the filtered list, start from the last station
      if (currentStation == null || !stations.contains(currentStation)) {
        await selectStation(stations.last);
        return;
      }

      final currentIndex = stations.indexOf(currentStation);
      final previousIndex =
          currentIndex == 0 ? stations.length - 1 : currentIndex - 1;
      final previousStation = stations[previousIndex];

      await selectStation(previousStation);
    } catch (e) {
      _handleAndEmitError(e);
    }
  }

  /// Toggles the favorite status of a station
  ///
  /// This method:
  /// 1. Toggles the favorite status of the specified station via [_toggleFavoriteUseCase]
  /// 2. Updates the station in the current list with the new favorite status
  /// 3. If the toggled station is currently selected, updates the selected station as well
  /// 4. Emits a new state with the updated stations
  ///
  /// Parameters:
  /// - [station]: The radio station to toggle the favorite status for
  ///
  /// Any errors during the operation are handled via [_handleAndEmitError].
  Future<void> toggleStationFavorite(RadioStation station) async {
    final loadedState = _getLoadedState();
    if (loadedState == null) return;

    try {
      await _toggleFavoriteUseCase.execute(station);

      // Update the station in the current list instead of reloading
      final updatedStations =
          loadedState.stations.map((s) {
            if (s.uuid == station.uuid) {
              return station.copyWith(isFavorite: !s.isFavorite);
            }
            return s;
          }).toList();

      emit(
        loadedState.copyWith(
          stations: updatedStations,
          selectedStation:
              loadedState.selectedStation?.uuid == station.uuid
                  ? station.copyWith(isFavorite: !station.isFavorite)
                  : loadedState.selectedStation,
        ),
      );
    } catch (e) {
      _handleAndEmitError(e);
    }
  }

  /// Sets the volume level
  ///
  /// This method:
  /// 1. Adds the provided value to the current volume level
  /// 2. Ensures the volume stays within valid bounds (0.0 to 1.0)
  /// 3. Applies the new volume level via [_setVolumeUseCase]
  ///
  /// Parameters:
  /// - [volume]: The amount to adjust the volume by:
  ///   - Positive values increase volume
  ///   - Negative values decrease volume
  ///
  /// The actual volume change will be reflected in the state via the
  /// [_listenToVolumeChanges] subscription.
  ///
  /// Any errors during the operation are handled via [_handleAndEmitError].
  Future<void> setVolume(double volume) async {
    final loadedState = _getLoadedState();
    if (loadedState == null) return;

    try {
      final currentVolume = loadedState.volume;
      final newVolume = (currentVolume + volume).clamp(0.0, 1.0);

      await _setVolumeUseCase.execute(newVolume);
    } catch (e) {
      _handleAndEmitError(e);
    }
  }

  /// Helper method to handle errors consistently
  ///
  /// This method:
  /// 1. Formats an appropriate error message based on the error type
  /// 2. Emits a [RadioPageErrorState] to display the error to the user
  ///
  /// Parameters:
  /// - [error]: The error object to handle
  ///
  /// If the error is a [RadioStationFailure], its message is used.
  /// Otherwise, a generic error message is created.
  void _handleAndEmitError(Object error) {
    final String errorMessage;
    if (error is RadioStationFailure) {
      errorMessage = error.message;
    } else {
      errorMessage = 'An unexpected error occurred: $error';
    }
    emit(RadioPageErrorState(errorMessage: errorMessage));
  }

  /// Helper method to safely get the loaded state
  ///
  /// This method:
  /// 1. Checks if the current state is a [RadioPageLoadedState]
  /// 2. Returns the state cast to [RadioPageLoadedState] if it is
  /// 3. Returns null if the state is not a [RadioPageLoadedState]
  ///
  /// This helper is used throughout the class to ensure type safety
  /// when accessing loaded state properties.
  ///
  /// Returns null if the current state is not [RadioPageLoadedState]
  RadioPageLoadedState? _getLoadedState() {
    if (state is! RadioPageLoadedState) return null;
    return state as RadioPageLoadedState;
  }
}
