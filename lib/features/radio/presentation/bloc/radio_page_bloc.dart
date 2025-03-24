import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:radio_stations/features/audio/domain/usecases/get_volume_stream_use_case.dart';
import 'package:radio_stations/features/radio/domain/domain.dart';
import 'package:radio_stations/features/radio/domain/use_cases/set_volume_use_case.dart';
import 'package:radio_stations/features/radio/domain/use_cases/toggle_favorite_radio_station_use_case.dart';
import 'package:radio_stations/features/radio/presentation/bloc/radio_page_events.dart';
import 'package:radio_stations/features/radio/presentation/bloc/radio_page_states.dart';
import 'package:radio_stations/features/shared/domain/events/error_event_bus.dart';

/// The BLoC that manages the radio page state following BLoC pattern
class RadioPageBloc extends Bloc<RadioPageEvent, RadioPageState> {
  /// Creates a new instance of [RadioPageBloc]
  ///
  /// This constructor initializes the bloc with all required dependencies.
  RadioPageBloc({
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
       super(const RadioPageInitial()) {
    // Register event handlers
    on<RadioPageInitialized>(_onInitialized);
    on<RadioStationsRequested>(_onRadioStationsRequested);
    on<FavoritesFilterToggled>(_onFavoritesFilterToggled);
    on<CountrySelected>(_onCountrySelected);
    on<RadioStationSelected>(_onRadioStationSelected);
    on<PlaybackToggled>(_onPlaybackToggled);
    on<NextStationRequested>(_onNextStationRequested);
    on<PreviousStationRequested>(_onPreviousStationRequested);
    on<StationFavoriteToggled>(_onStationFavoriteToggled);
    on<VolumeChanged>(_onVolumeChanged);
    on<ErrorOccurred>(_onErrorOccurred);
    on<StationMarkedAsBroken>(_onStationMarkedAsBroken);
    on<PlaybackStateChanged>(_onPlaybackStateChanged);
    on<VolumeStateChanged>(_onVolumeStateChanged);
    on<SyncProgressUpdated>(_onSyncProgressUpdated);
  }
  // ========== Use Cases ==========

  final GetRadioStationListUseCase _getRadioStationListUseCase;
  final SyncRadioStationsUseCase _syncStationsUseCase;
  final PlayRadioStationUseCase _playRadioStationUseCase;
  final ToggleFavoriteRadioStationUseCase _toggleFavoriteUseCase;
  final GetPlaybackStateUseCase _getPlaybackStateUseCase;
  final TogglePlayPauseUseCase _togglePlayPauseUseCase;
  final SetBrokenRadioStationUseCase _setBrokenRadioStationUseCase;
  final SetVolumeUseCase _setVolumeUseCase;
  final GetVolumeStreamUseCase _getVolumeStreamUseCase;
  final ErrorEventBus _errorEventBus;

  // ========== Subscriptions ==========

  StreamSubscription<RadioStation>? _errorSubscription;
  StreamSubscription<bool>? _playbackSubscription;
  StreamSubscription<double>? _volumeSubscription;

  // ========== Event Handlers ==========

  /// Handles initialization of the bloc
  Future<void> _onInitialized(
    RadioPageInitialized event,
    Emitter<RadioPageState> emit,
  ) async {
    try {
      // Load stations
      add(const RadioStationsRequested());

      // Set up listeners
      _setupSubscriptions();
    } catch (e) {
      add(ErrorOccurred(e));
    }
  }

  /// Handles request to load radio stations
  Future<void> _onRadioStationsRequested(
    RadioStationsRequested event,
    Emitter<RadioPageState> emit,
  ) async {
    try {
      final isLoadedState = state is RadioPageLoaded;
      final RadioPageLoaded? loadedState =
          isLoadedState ? state as RadioPageLoaded : null;

      if (event.forceSync) {
        await _syncStations(emit);
      }

      final filter =
          isLoadedState
              ? loadedState!.selectedFilter
              : const RadioStationFilter(favorite: false);

      // First try to get stations from local cache
      final stations = await _getRadioStationListUseCase.execute(filter);

      // If we have no stations and forceSync is false
      if (stations.isEmpty && !event.forceSync) {
        await _syncStations(emit);
        stations.addAll(await _getRadioStationListUseCase.execute(filter));
      }

      // Update available countries
      final countries =
          await _getRadioStationListUseCase.getAvailableCountries();

      emit(
        RadioPageLoaded(
          stations: stations,
          selectedStation: loadedState?.selectedStation,
          countries: countries,
          selectedFilter:
              loadedState?.selectedFilter ??
              const RadioStationFilter(favorite: false),
          isPlaying: loadedState?.isPlaying ?? false,
          volume: loadedState?.volume ?? 1.0,
        ),
      );
    } catch (e) {
      add(ErrorOccurred(e));
    }
  }

  /// Handles toggling of favorites filter
  Future<void> _onFavoritesFilterToggled(
    FavoritesFilterToggled event,
    Emitter<RadioPageState> emit,
  ) async {
    if (state is! RadioPageLoaded) return;
    final loadedState = state as RadioPageLoaded;

    try {
      final currentFilter = loadedState.selectedFilter;
      final filter = currentFilter.toggleFavorite();
      final stations = await _getRadioStationListUseCase.execute(filter);

      emit(loadedState.copyWith(stations: stations, selectedFilter: filter));
    } catch (e) {
      add(ErrorOccurred(e));
    }
  }

  /// Handles selection of a country filter
  Future<void> _onCountrySelected(
    CountrySelected event,
    Emitter<RadioPageState> emit,
  ) async {
    if (state is! RadioPageLoaded) return;
    final loadedState = state as RadioPageLoaded;

    try {
      final currentFilter = loadedState.selectedFilter;
      final filter =
          event.country == null
              ? currentFilter.withoutCountry()
              : currentFilter.withCountry(event.country!);

      final stations = await _getRadioStationListUseCase.execute(filter);

      emit(loadedState.copyWith(stations: stations, selectedFilter: filter));
    } catch (e) {
      add(ErrorOccurred(e));
    }
  }

  /// Handles selection of a radio station
  Future<void> _onRadioStationSelected(
    RadioStationSelected event,
    Emitter<RadioPageState> emit,
  ) async {
    if (state is! RadioPageLoaded) return;
    final loadedState = state as RadioPageLoaded;

    // If the same station is selected, do nothing
    if (loadedState.selectedStation?.uuid == event.station.uuid) {
      return;
    }

    try {
      // First update UI state
      emit(loadedState.copyWith(selectedStation: event.station));

      // Then start playing the station
      await _playRadioStationUseCase.execute(event.station);
    } catch (e) {
      add(ErrorOccurred(e));
    }
  }

  /// Handles toggle of play/pause
  Future<void> _onPlaybackToggled(
    PlaybackToggled event,
    Emitter<RadioPageState> emit,
  ) async {
    if (state is! RadioPageLoaded) return;
    final loadedState = state as RadioPageLoaded;

    if (loadedState.selectedStation == null) return;

    try {
      await _togglePlayPauseUseCase.execute();
      // State will be updated via the playback state subscription
    } catch (e) {
      add(ErrorOccurred(e));
    }
  }

  /// Handles request to play the next station
  Future<void> _onNextStationRequested(
    NextStationRequested event,
    Emitter<RadioPageState> emit,
  ) async {
    if (state is! RadioPageLoaded) return;
    final loadedState = state as RadioPageLoaded;

    final currentStation = loadedState.selectedStation;
    final stations = loadedState.stations;

    if (stations.isEmpty) return;

    try {
      // If current station is not in the filtered list, start from the first station
      if (currentStation == null || !stations.contains(currentStation)) {
        add(RadioStationSelected(stations.first));
        return;
      }

      final currentIndex = stations.indexOf(currentStation);
      final nextIndex = (currentIndex + 1) % stations.length;
      final nextStation = stations[nextIndex];

      add(RadioStationSelected(nextStation));
    } catch (e) {
      add(ErrorOccurred(e));
    }
  }

  /// Handles request to play the previous station
  Future<void> _onPreviousStationRequested(
    PreviousStationRequested event,
    Emitter<RadioPageState> emit,
  ) async {
    if (state is! RadioPageLoaded) return;
    final loadedState = state as RadioPageLoaded;

    final currentStation = loadedState.selectedStation;
    final stations = loadedState.stations;

    if (stations.isEmpty) return;

    try {
      // If current station is not in the filtered list, start from the last station
      if (currentStation == null || !stations.contains(currentStation)) {
        add(RadioStationSelected(stations.last));
        return;
      }

      final currentIndex = stations.indexOf(currentStation);
      final previousIndex =
          currentIndex == 0 ? stations.length - 1 : currentIndex - 1;
      final previousStation = stations[previousIndex];

      add(RadioStationSelected(previousStation));
    } catch (e) {
      add(ErrorOccurred(e));
    }
  }

  /// Handles toggling favorite status of a station
  Future<void> _onStationFavoriteToggled(
    StationFavoriteToggled event,
    Emitter<RadioPageState> emit,
  ) async {
    if (state is! RadioPageLoaded) return;
    final loadedState = state as RadioPageLoaded;

    try {
      await _toggleFavoriteUseCase.execute(event.station);

      // Update the station in the current list
      final updatedStations =
          loadedState.stations.map((s) {
            if (s.uuid == event.station.uuid) {
              return event.station.copyWith(isFavorite: !s.isFavorite);
            }
            return s;
          }).toList();

      emit(
        loadedState.copyWith(
          stations: updatedStations,
          selectedStation:
              loadedState.selectedStation?.uuid == event.station.uuid
                  ? event.station.copyWith(
                    isFavorite: !event.station.isFavorite,
                  )
                  : loadedState.selectedStation,
        ),
      );
    } catch (e) {
      add(ErrorOccurred(e));
    }
  }

  /// Handles volume change requests
  Future<void> _onVolumeChanged(
    VolumeChanged event,
    Emitter<RadioPageState> emit,
  ) async {
    if (state is! RadioPageLoaded) return;
    final loadedState = state as RadioPageLoaded;

    try {
      final currentVolume = loadedState.volume;
      final newVolume = (currentVolume + event.delta).clamp(0.0, 1.0);

      await _setVolumeUseCase.execute(newVolume);
      // State will be updated via the volume subscription
    } catch (e) {
      add(ErrorOccurred(e));
    }
  }

  /// Handles error events
  void _onErrorOccurred(ErrorOccurred event, Emitter<RadioPageState> emit) {
    final String errorMessage;
    if (event.error is RadioStationFailure) {
      errorMessage = (event.error as RadioStationFailure).message;
    } else {
      errorMessage = 'An unexpected error occurred: ${event.error}';
    }

    emit(
      RadioPageError(
        errorMessage: errorMessage,
        previousState: state is RadioPageInitial ? null : state,
      ),
    );
  }

  /// Handles when a station is marked as broken
  void _onStationMarkedAsBroken(
    StationMarkedAsBroken event,
    Emitter<RadioPageState> emit,
  ) {
    if (state is! RadioPageLoaded) return;
    final loadedState = state as RadioPageLoaded;

    final stations =
        loadedState.stations.map((s) {
          if (s.uuid == event.station.uuid) {
            return event.station.copyWith(broken: true);
          }
          return s;
        }).toList();

    emit(loadedState.copyWith(stations: stations));
    _setBrokenRadioStationUseCase.execute(event.station);
  }

  /// Handles playback state changes from external sources
  void _onPlaybackStateChanged(
    PlaybackStateChanged event,
    Emitter<RadioPageState> emit,
  ) {
    if (state is! RadioPageLoaded) return;
    final loadedState = state as RadioPageLoaded;

    emit(loadedState.copyWith(isPlaying: event.isPlaying));
  }

  /// Handles volume state changes from external sources
  void _onVolumeStateChanged(
    VolumeStateChanged event,
    Emitter<RadioPageState> emit,
  ) {
    if (state is! RadioPageLoaded) return;
    final loadedState = state as RadioPageLoaded;

    emit(loadedState.copyWith(volume: event.volume));
  }

  /// Handles sync progress updates
  void _onSyncProgressUpdated(
    SyncProgressUpdated event,
    Emitter<RadioPageState> emit,
  ) {
    emit(
      RadioPageSyncProgress(
        totalStations: event.totalStations,
        downloadedStations: event.downloadedStations,
      ),
    );
  }

  // ========== Helper Methods ==========

  /// Sets up subscriptions to external streams
  void _setupSubscriptions() {
    // Listen to error events
    _errorSubscription = _errorEventBus.stream.listen(
      (station) => add(StationMarkedAsBroken(station)),
      onError: (dynamic e) => add(ErrorOccurred(e)),
    );

    // Listen to playback state changes
    _playbackSubscription = _getPlaybackStateUseCase.playingStateStream.listen(
      (isPlaying) => add(PlaybackStateChanged(isPlaying: isPlaying)),
      onError: (dynamic e) => add(ErrorOccurred(e)),
    );

    // Listen to volume changes
    _volumeSubscription = _getVolumeStreamUseCase().listen(
      (volume) => add(VolumeStateChanged(volume)),
      onError: (dynamic e) => add(ErrorOccurred(e)),
    );
  }

  /// Synchronizes stations with remote source
  Future<void> _syncStations(Emitter<RadioPageState> emit) async {
    try {
      emit(
        const RadioPageSyncProgress(totalStations: 0, downloadedStations: 0),
      );

      await _syncStationsUseCase.execute(
        onProgress: (total, downloaded) {
          try {
            // Ensure downloaded never exceeds total
            final validDownloaded = downloaded > total ? total : downloaded;
            add(
              SyncProgressUpdated(
                totalStations: total,
                downloadedStations: validDownloaded,
              ),
            );
          } catch (e) {
            add(ErrorOccurred(e));
          }
        },
      );
    } catch (e) {
      add(ErrorOccurred(e));
    }
  }

  @override
  Future<void> close() async {
    await _errorSubscription?.cancel();
    await _playbackSubscription?.cancel();
    await _volumeSubscription?.cancel();
    return super.close();
  }
}
