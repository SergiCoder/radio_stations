import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:radio_stations/features/radio/domain/domain.dart';
import 'package:radio_stations/features/radio/domain/use_cases/toggle_favorite_radio_station_use_case.dart';
import 'package:radio_stations/features/radio/presentation/pages/radio_page.dart';
import 'package:radio_stations/features/radio/presentation/state/radio_page_state.dart';

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
  /// [getStationByIdUseCase] is used to get a station by ID and handle its playback
  /// [toggleFavoriteUseCase] is used to toggle the favorite status of a station
  /// [getPlaybackStateUseCase] is used to get the current playback state
  /// [togglePlayPauseUseCase] is used to toggle play/pause
  RadioPageCubit({
    required this.getRadioStationListUseCase,
    required this.syncStationsUseCase,
    required this.getStationByIdUseCase,
    required this.toggleFavoriteUseCase,
    required this.getPlaybackStateUseCase,
    required this.togglePlayPauseUseCase,
  }) : super(
         const RadioPageSyncProgressState(
           totalStations: 0,
           downloadedStations: 0,
         ),
       );

  /// The use case for getting all radio stations
  final GetRadioStationListUseCase getRadioStationListUseCase;

  /// The use case for synchronizing radio stations with a remote source
  final SyncRadioStationsUseCase syncStationsUseCase;

  /// The use case for getting a radio station by ID and handling its playback
  final GetRadioStationByIdUseCase getStationByIdUseCase;

  /// The use case for toggling the favorite status of a station
  final ToggleFavoriteRadioStationUseCase toggleFavoriteUseCase;

  /// The use case for getting the current playback state
  final GetPlaybackStateUseCase getPlaybackStateUseCase;

  /// The use case for toggling play/pause
  final TogglePlayPauseUseCase togglePlayPauseUseCase;

  /// The list of available countries
  List<String> _countries = [];

  /// The currently selected country
  String? _selectedCountry;

  /// The favorite filter state: null = disabled, true = favorites only, false = non-favorites only
  bool _showFavorites = false;

  /// Gets the list of available countries
  List<String> get countries => _countries;

  /// Gets the currently selected country
  String? get selectedCountry => _selectedCountry;

  /// Gets whether to show only favorite stations
  bool get showFavorites => _showFavorites;

  /// Initializes the cubit and loads the stations
  ///
  /// This method should be called right after creating the cubit.
  Future<void> init() async {
    await loadStations();
    _listenToPlaybackState();
  }

  /// Listens to playback state changes and updates the UI accordingly
  void _listenToPlaybackState() {
    getPlaybackStateUseCase.playingStateStream.listen((isPlaying) {
      if (state is RadioPageLoadedState) {
        final loadedState = state as RadioPageLoadedState;
        emit(loadedState.copyWith());
      }
    });
  }

  Future<void> _syncStations() async {
    emit(
      const RadioPageSyncProgressState(totalStations: 0, downloadedStations: 0),
    );
    await syncStationsUseCase.execute(
      onProgress: (total, downloaded) {
        emit(
          RadioPageSyncProgressState(
            totalStations: total,
            downloadedStations: downloaded,
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
      if (forceSync) {
        await _syncStations();
      }

      // First try to get stations from local cache
      final stations = await getRadioStationListUseCase.execute(
        _createFilter(),
      );

      // If we have stations and forceSync is false, just use them
      if (stations.isNotEmpty) {
        // Update available countries and languages
        _countries = await getRadioStationListUseCase.getAvailableCountries();
        emit(RadioPageLoadedState(stations: stations));
        return;
      }

      emit(const RadioPageEmptyState());
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

  /// Creates a filter based on current selection
  RadioStationFilter _createFilter() {
    return RadioStationFilter(
      country: _selectedCountry,
      favorite: _showFavorites,
    );
  }

  /// Handles the selection of a radio station
  ///
  /// [station] is the station that was selected
  Future<void> selectStation(RadioStation station) async {
    if (state is! RadioPageLoadedState) return;

    final loadedState = state as RadioPageLoadedState;

    // If the same station is selected, toggle play/pause
    if (loadedState.selectedStation?.uuid == station.uuid) {
      return;
    }
    emit(loadedState.copyWith(selectedStation: station));
    await getStationByIdUseCase.execute(station);
  }

  /// Handles play/pause for the current station
  Future<void> togglePlayPause() async {
    if (state is! RadioPageLoadedState) return;
    final loadedState = state as RadioPageLoadedState;
    if (loadedState.selectedStation == null) return;

    await togglePlayPauseUseCase.execute();
  }

  /// Handles skipping to the next station
  Future<void> nextStation() async {
    if (state is! RadioPageLoadedState) return;

    final loadedState = state as RadioPageLoadedState;
    final currentStation = loadedState.selectedStation;

    if (currentStation == null) return;

    final currentIndex = loadedState.stations.indexOf(currentStation);
    if (currentIndex == -1) return;

    final nextIndex = (currentIndex + 1) % loadedState.stations.length;
    final nextStation = loadedState.stations[nextIndex];

    await selectStation(nextStation);
  }

  /// Handles skipping to the previous station
  Future<void> previousStation() async {
    if (state is! RadioPageLoadedState) return;

    final loadedState = state as RadioPageLoadedState;
    final currentStation = loadedState.selectedStation;

    if (currentStation == null) return;

    final currentIndex = loadedState.stations.indexOf(currentStation);
    if (currentIndex == -1) return;

    final previousIndex =
        currentIndex == 0 ? loadedState.stations.length - 1 : currentIndex - 1;
    final previousStation = loadedState.stations[previousIndex];

    await selectStation(previousStation);
  }

  /// Handles toggling the favorite filter
  Future<void> toggleFavorites() async {
    if (state is! RadioPageLoadedState) return;

    _showFavorites = !_showFavorites;
    final stations = await getRadioStationListUseCase.execute(_createFilter());
    final loadedState = state as RadioPageLoadedState;

    emit(
      loadedState.copyWith(
        stations: stations,
        selectedStation: loadedState.selectedStation,
      ),
    );
  }

  /// Handles setting the selected country
  Future<void> setSelectedCountry(String? country) async {
    if (state is! RadioPageLoadedState) return;
    if (country == null) return;
    _selectedCountry = country;
    final stations = await getRadioStationListUseCase.execute(_createFilter());
    final loadedState = state as RadioPageLoadedState;

    emit(
      loadedState.copyWith(
        stations: stations,
        selectedStation: loadedState.selectedStation,
      ),
    );
  }

  /// Toggles the favorite status of a station
  ///
  /// [station] is the station to toggle
  Future<void> toggleStationFavorite(RadioStation station) async {
    if (state is! RadioPageLoadedState) return;

    try {
      await toggleFavoriteUseCase.execute(station);
      await _updateFilteredStations();
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

  /// Updates the filtered stations based on current filters
  Future<void> _updateFilteredStations() async {
    if (state is! RadioPageLoadedState) return;

    try {
      final loadedState = state as RadioPageLoadedState;
      final stations = await getRadioStationListUseCase.execute(
        _createFilter(),
      );
      emit(loadedState.copyWith(stations: stations));
    } catch (e) {
      final String errorMessage;
      if (e is RadioStationFailure) {
        errorMessage = e.message;
      } else {
        errorMessage = 'Failed to update stations: $e';
      }

      emit(RadioPageErrorState(errorMessage: errorMessage));
    }
  }

  /// Gets whether a station is currently playing
  ///
  /// Returns true if a station is currently playing, false otherwise.
  /// This is determined by checking the current state and the audio repository's
  /// playing state.
  bool get isPlaying {
    if (state is! RadioPageLoadedState) return false;
    final loadedState = state as RadioPageLoadedState;
    return loadedState.selectedStation != null &&
        getPlaybackStateUseCase.isPlaying;
  }
}
