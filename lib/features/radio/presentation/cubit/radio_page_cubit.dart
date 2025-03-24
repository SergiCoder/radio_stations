import 'dart:async';

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
/// user interactions with the radio page.
class RadioPageCubit extends Cubit<RadioPageState> {
  /// Creates a new instance of [RadioPageCubit]
  ///
  /// [getRadioStationListUseCase] is used to fetch all radio stations
  /// [syncStationsUseCase] is used to synchronize radio stations with a remote
  /// source
  /// [playRadioStationUseCase] is used to play a radio station
  /// [toggleFavoriteUseCase] is used to toggle the favorite status of a station
  /// [getPlaybackStateUseCase] is used to get the current playback state
  /// [togglePlayPauseUseCase] is used to toggle play/pause
  /// [setVolumeUseCase] is used to control the audio volume
  /// [getVolumeStreamUseCase] is used to get volume changes
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

  final ErrorEventBus _errorEventBus;

  /// The use case for getting all radio stations
  final GetRadioStationListUseCase _getRadioStationListUseCase;

  /// The use case for synchronizing radio stations with a remote source
  final SyncRadioStationsUseCase _syncStationsUseCase;

  /// The use case for playing a radio station
  final PlayRadioStationUseCase _playRadioStationUseCase;

  /// The use case for toggling the favorite status of a station
  final ToggleFavoriteRadioStationUseCase _toggleFavoriteUseCase;

  /// The use case for getting the current playback state
  final GetPlaybackStateUseCase _getPlaybackStateUseCase;

  /// The use case for toggling play/pause
  final TogglePlayPauseUseCase _togglePlayPauseUseCase;

  /// The use case for setting a radio station as broken
  final SetBrokenRadioStationUseCase _setBrokenRadioStationUseCase;

  /// The use case for controlling audio volume
  final SetVolumeUseCase _setVolumeUseCase;

  /// The use case for getting volume changes
  final GetVolumeStreamUseCase _getVolumeStreamUseCase;

  /// Subscription to error events
  StreamSubscription<RadioStation>? _errorSubscription;

  /// Subscription to playback state changes
  StreamSubscription<bool>? _playbackSubscription;

  /// Subscription to volume changes
  StreamSubscription<double>? _volumeSubscription;

  /// Initializes the cubit and loads the stations
  ///
  /// This method should be called right after creating the cubit.
  Future<void> init() async {
    await loadStations();
    _listenToPlaybackState();
    _listenToErrorEvents();
    _listenToVolumeChanges();
  }

  void _listenToErrorEvents() {
    _errorSubscription = _errorEventBus.stream.listen((station) {
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
    });
  }

  /// Listens to playback state changes and updates the UI accordingly
  void _listenToPlaybackState() {
    _playbackSubscription = _getPlaybackStateUseCase.playingStateStream.listen((
      isPlaying,
    ) {
      if (state is RadioPageLoadedState) {
        final loadedState = state as RadioPageLoadedState;
        emit(loadedState.copyWith(isPlaying: isPlaying));
      }
    });
  }

  /// Listens to volume changes and updates the UI accordingly
  void _listenToVolumeChanges() {
    _volumeSubscription = _getVolumeStreamUseCase().listen((volume) {
      if (state is RadioPageLoadedState) {
        final loadedState = state as RadioPageLoadedState;
        emit(loadedState.copyWith(volume: volume));
      }
    });
  }

  @override
  Future<void> close() async {
    await _errorSubscription?.cancel();
    await _playbackSubscription?.cancel();
    await _volumeSubscription?.cancel();
    await super.close();
  }

  Future<void> _syncStations() async {
    emit(
      const RadioPageSyncProgressState(totalStations: 0, downloadedStations: 0),
    );
    await _syncStationsUseCase.execute(
      onProgress: (total, downloaded) {
        // Ensure downloaded never exceeds total
        final validDownloaded = downloaded > total ? total : downloaded;
        emit(
          RadioPageSyncProgressState(
            totalStations: total,
            downloadedStations: validDownloaded,
          ),
        );
      },
    );
  }

  /// Loads radio stations from the local data source
  ///
  /// If [forceSync] is true, it will synchronize with the remote source first.
  /// Otherwise, it will only sync if there are no stations locally.
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
        ),
      );
    } catch (e) {
      final String errorMessage;
      if (e is RadioStationFailure) {
        errorMessage = e.message;
      } else {
        errorMessage = 'Failed to load stations: $e';
      }

      emit(RadioPageErrorState(errorMessage: errorMessage));
    }
  }

  /// Handles toggling the favorite filter
  Future<void> toggleFavorites() async {
    if (state is! RadioPageLoadedState) return;

    final loadedState = state as RadioPageLoadedState;
    final currentFilter = loadedState.selectedFilter;
    final filter = currentFilter.toggleFavorite();
    final stations = await _getRadioStationListUseCase.execute(filter);

    emit(
      loadedState.copyWith(
        stations: stations,
        selectedStation: loadedState.selectedStation,
        selectedFilter: filter,
      ),
    );
  }

  /// Sets the selected country and updates the stations list
  Future<void> setSelectedCountry(String? country) async {
    if (state is! RadioPageLoadedState) return;

    final loadedState = state as RadioPageLoadedState;
    final currentFilter = loadedState.selectedFilter;
    final filter =
        country == null
            ? currentFilter.withoutCountry()
            : currentFilter.withCountry(country);
    final stations = await _getRadioStationListUseCase.execute(filter);

    emit(loadedState.copyWith(stations: stations, selectedFilter: filter));
  }

  /// Handles the selection of a radio station
  ///
  /// [station] is the station that was selected
  Future<void> selectStation(RadioStation station) async {
    if (state is! RadioPageLoadedState) return;

    final loadedState = state as RadioPageLoadedState;

    // If the same station is selected, do nothing
    if (loadedState.selectedStation?.uuid == station.uuid) {
      return;
    }
    emit(loadedState.copyWith(selectedStation: station));

    await _playRadioStationUseCase.execute(station);
  }

  /// Handles play/pause for the current station
  Future<void> togglePlayPause() async {
    if (state is! RadioPageLoadedState) return;
    final loadedState = state as RadioPageLoadedState;
    if (loadedState.selectedStation == null) return;

    await _togglePlayPauseUseCase.execute();
  }

  /// Handles skipping to the next station
  ///
  /// If there is no next station, it will skip to the first station.
  Future<void> nextStation() async {
    if (state is! RadioPageLoadedState) return;

    final loadedState = state as RadioPageLoadedState;
    final currentStation = loadedState.selectedStation;
    final stations = loadedState.stations;

    if (stations.isEmpty) return;

    // If current station is not in the filtered list, start from the first station
    if (currentStation == null || !stations.contains(currentStation)) {
      await selectStation(stations.first);
      return;
    }

    final currentIndex = stations.indexOf(currentStation);
    final nextIndex = (currentIndex + 1) % stations.length;
    final nextStation = stations[nextIndex];

    await selectStation(nextStation);
  }

  /// Handles skipping to the previous station, if there is no previous station,
  /// it will skip to the last station
  Future<void> previousStation() async {
    if (state is! RadioPageLoadedState) return;

    final loadedState = state as RadioPageLoadedState;
    final currentStation = loadedState.selectedStation;
    final stations = loadedState.stations;

    if (stations.isEmpty) return;

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
  }

  /// Toggles the favorite status of a station
  ///
  /// [station] is the station to toggle
  Future<void> toggleStationFavorite(RadioStation station) async {
    if (state is! RadioPageLoadedState) return;

    try {
      await _toggleFavoriteUseCase.execute(station);
      await loadStations();
    } catch (e) {
      final String errorMessage;
      if (e is RadioStationFailure) {
        errorMessage = e.message;
      } else {
        errorMessage = 'Failed to toggle favorite: $e';
      }

      emit(RadioPageErrorState(errorMessage: errorMessage));
    }
  }

  /// Sets the volume level
  ///
  /// [volume] is the volume level between 0.0 and 1.0, or a relative change
  /// (positive for increase, negative for decrease)
  Future<void> setVolume(double volume) async {
    if (state is! RadioPageLoadedState) return;

    final loadedState = state as RadioPageLoadedState;
    final currentVolume = loadedState.volume;
    final newVolume = (currentVolume + volume).clamp(0.0, 1.0);

    await _setVolumeUseCase.execute(newVolume);
  }
}
