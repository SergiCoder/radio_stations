import 'package:radio_stations/features/radio/domain/domain.dart';

/// Base class for all radio page events.
///
/// Events represent actions or occurrences that can change the state of the
/// radio page. All concrete events extend this class to maintain a consistent
/// approach to event handling in the BLoC pattern.
abstract class RadioPageEvent {
  /// Creates a new [RadioPageEvent] instance.
  const RadioPageEvent();
}

/// Event dispatched when the radio page needs to be initialized.
///
/// This event is typically dispatched once when the page is first loaded.
/// It triggers the initial loading of radio stations and sets up necessary
/// subscriptions for playback state changes, error events, and volume changes.
class RadioPageInitialized extends RadioPageEvent {
  /// Creates a new [RadioPageInitialized] event.
  const RadioPageInitialized();
}

/// Event dispatched to request loading of radio stations.
///
/// This event triggers the loading of radio stations from the local cache,
/// with an option to force synchronization with the remote source first.
/// It's used both during initialization and when the user explicitly requests
/// a refresh of the stations list.
class RadioStationsRequested extends RadioPageEvent {
  /// Creates a new [RadioStationsRequested] event.
  ///
  /// [forceSync] defaults to false, meaning the BLoC will first try to use
  /// cached data before syncing with the remote source.
  const RadioStationsRequested({this.forceSync = false});

  /// Whether to force synchronization with the remote source.
  ///
  /// When true, the BLoC will always fetch fresh data from the remote source
  /// before loading stations. When false, it will first try to use cached data
  /// and only sync if the cache is empty.
  final bool forceSync;
}

/// Event dispatched to toggle the favorites filter.
///
/// This event triggers toggling between showing all stations and showing only
/// favorite stations. It's typically dispatched when the user taps a favorites
/// filter button in the UI.
class FavoritesFilterToggled extends RadioPageEvent {
  /// Creates a new [FavoritesFilterToggled] event.
  const FavoritesFilterToggled();
}

/// Event dispatched when a country filter is selected.
///
/// This event triggers filtering of the stations list to show only stations
/// from the specified country. Setting the country to null removes the country
/// filter, showing stations from all countries (subject to other filters).
class CountrySelected extends RadioPageEvent {
  /// Creates a new [CountrySelected] event.
  ///
  /// [country] is the country code to filter by, or null to show all countries.
  const CountrySelected(this.country);

  /// The country code to filter by, or null to show all countries.
  ///
  /// When specified, only stations from this country will be shown.
  /// When null, stations from all countries will be shown (subject to other filters).
  final String? country;
}

/// Event dispatched when a radio station is selected.
///
/// This event triggers selection and playback of the specified radio station.
/// It's typically dispatched when the user taps on a station in the stations list.
class RadioStationSelected extends RadioPageEvent {
  /// Creates a new [RadioStationSelected] event.
  ///
  /// [station] is the radio station to select and play.
  const RadioStationSelected(this.station);

  /// The radio station to select and play.
  ///
  /// This station will become the currently selected station, and playback
  /// will start automatically.
  final RadioStation station;
}

/// Event dispatched to toggle playback between play and pause.
///
/// This event triggers toggling between playing and pausing the currently selected
/// station. If no station is currently selected, the event has no effect.
/// It's typically dispatched when the user taps a play/pause button in the UI.
class PlaybackToggled extends RadioPageEvent {
  /// Creates a new [PlaybackToggled] event.
  const PlaybackToggled();
}

/// Event dispatched to request playback of the next station.
///
/// This event triggers selection and playback of the next station in the current
/// filtered list. If the current station is the last one, it will cycle back to
/// the first station. If no station is currently selected, it will start with
/// the first station.
class NextStationRequested extends RadioPageEvent {
  /// Creates a new [NextStationRequested] event.
  const NextStationRequested();
}

/// Event dispatched to request playback of the previous station.
///
/// This event triggers selection and playback of the previous station in the
/// current filtered list. If the current station is the first one, it will
/// cycle to the last station. If no station is currently selected, it will
/// start with the last station.
class PreviousStationRequested extends RadioPageEvent {
  /// Creates a new [PreviousStationRequested] event.
  const PreviousStationRequested();
}

/// Event dispatched to toggle the favorite status of a station.
///
/// This event triggers adding or removing a station from the user's favorites.
/// It's typically dispatched when the user taps a favorite/heart icon next to
/// a station in the UI.
class StationFavoriteToggled extends RadioPageEvent {
  /// Creates a new [StationFavoriteToggled] event.
  ///
  /// [station] is the radio station to toggle the favorite status for.
  const StationFavoriteToggled(this.station);

  /// The radio station to toggle the favorite status for.
  ///
  /// If the station is currently a favorite, it will be removed from favorites.
  /// If it's not a favorite, it will be added to favorites.
  final RadioStation station;
}

/// Event dispatched to change the playback volume.
///
/// This event triggers a change in the audio playback volume. The volume is
/// adjusted relative to the current volume level, clamped between 0.0 and 1.0.
/// It's typically dispatched when the user interacts with a volume control in the UI.
class VolumeChanged extends RadioPageEvent {
  /// Creates a new [VolumeChanged] event.
  ///
  /// [delta] is the amount to adjust the volume by (positive or negative).
  const VolumeChanged(this.delta);

  /// The amount to adjust the volume by.
  ///
  /// Positive values increase the volume, negative values decrease it.
  /// The resulting volume will be clamped between 0.0 (silent) and 1.0 (maximum).
  final double delta;
}

/// Event dispatched when an error occurs.
///
/// This event is typically dispatched internally by the BLoC when an error
/// occurs during an operation. It triggers a transition to an error state,
/// capturing and formatting the error message for display to the user.
class ErrorOccurred extends RadioPageEvent {
  /// Creates a new [ErrorOccurred] event.
  ///
  /// [error] is the error that occurred.
  const ErrorOccurred(this.error);

  /// The error that occurred.
  ///
  /// This can be any object, but is typically an Exception or Error instance.
  /// If it's a [RadioStationFailure], its message will be used directly.
  /// Otherwise, a generic error message will be created.
  final dynamic error;
}

/// Event dispatched when a station is marked as broken.
///
/// This event is typically dispatched internally when a station fails to play
/// or encounters an error. It triggers updating the station's broken status
/// in the UI and persisting this status to the local data source.
class StationMarkedAsBroken extends RadioPageEvent {
  /// Creates a new [StationMarkedAsBroken] event.
  ///
  /// [station] is the radio station to mark as broken.
  const StationMarkedAsBroken(this.station);

  /// The radio station to mark as broken.
  ///
  /// This station will be updated with broken=true in the UI and data source.
  final RadioStation station;
}

/// Event dispatched when the playback state changes.
///
/// This event is typically dispatched internally by the BLoC in response to
/// external playback state changes (like when a station starts or stops playing).
/// It triggers updating the UI to reflect the current playback state.
class PlaybackStateChanged extends RadioPageEvent {
  /// Creates a new [PlaybackStateChanged] event.
  ///
  /// [isPlaying] indicates whether audio is currently playing.
  const PlaybackStateChanged({required this.isPlaying});

  /// Whether audio is currently playing.
  ///
  /// True if a station is currently playing, false if paused or stopped.
  final bool isPlaying;
}

/// Event dispatched when the volume level changes.
///
/// This event is typically dispatched internally by the BLoC in response to
/// external volume changes. It triggers updating the UI to reflect the current
/// volume level.
class VolumeStateChanged extends RadioPageEvent {
  /// Creates a new [VolumeStateChanged] event.
  ///
  /// [volume] is the current volume level (0.0 to 1.0).
  const VolumeStateChanged(this.volume);

  /// The current volume level.
  ///
  /// The volume level ranges from 0.0 (silent) to 1.0 (maximum).
  final double volume;
}

/// Event dispatched when synchronization progress changes.
///
/// This event is typically dispatched internally by the BLoC during synchronization
/// with the remote source. It triggers updating the UI to show the current
/// synchronization progress to the user.
class SyncProgressUpdated extends RadioPageEvent {
  /// Creates a new [SyncProgressUpdated] event.
  ///
  /// [totalStations] is the total number of stations to synchronize.
  /// [downloadedStations] is the number of stations downloaded so far.
  const SyncProgressUpdated({
    required this.totalStations,
    required this.downloadedStations,
  });

  /// Total number of stations to synchronize.
  ///
  /// This represents the total count of stations that will be downloaded.
  final int totalStations;

  /// Number of stations downloaded so far.
  ///
  /// This represents the current progress of the synchronization process.
  /// It should never exceed [totalStations].
  final int downloadedStations;
}
