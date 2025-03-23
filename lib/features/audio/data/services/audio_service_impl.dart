import 'dart:async';
import 'dart:developer';

import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';
import 'package:radio_stations/features/audio/domain/use_cases/mark_radio_station_broken_usecase.dart';
import 'package:radio_stations/features/radio/domain/entities/radio_station.dart';

// Following the example of:
// https://github.com/suragch/audio_playlist_flutter_demo

/// Represents an audio service available across navigation to different
/// screens.
class AudioServiceImpl extends BaseAudioHandler {
  AudioServiceImpl._({
    required AudioPlayer player,
    required this.markStationBrokenUseCase,
  }) : _player = player {
    _notifyAudioHandlerAboutPlaybackEvents();
    _setupErrorHandling();
  }

  final AudioPlayer _player;

  /// Use case for marking radio stations as broken
  final MarkRadioStationBrokenUseCase markStationBrokenUseCase;

  /// Flag to prevent concurrent preparation of songs and control operations
  bool _isPreparing = false;

  RadioStation? _currentStation;

  /// Sets up error handling for the audio player
  void _setupErrorHandling() {
    _player.playbackEventStream.listen(
      (event) {},
      onError: (Object e, StackTrace stackTrace) {
        log('A stream error occurred: $e');
        if (_currentStation != null) {
          markStationBrokenUseCase.execute(_currentStation!);
        }
      },
      onDone: () {
        log('The stream is done');
      },
      cancelOnError: false,
    );
  }

  /// Async constructor for the audioService
  static Future<AudioServiceImpl> initAudioService({
    required AudioPlayer player,
    required MarkRadioStationBrokenUseCase markStationBrokenUseCase,
  }) async {
    final instance = await AudioService.init(
      builder:
          () => AudioServiceImpl._(
            player: player,
            markStationBrokenUseCase: markStationBrokenUseCase,
          ),
      config: const AudioServiceConfig(
        androidNotificationChannelId: 'radio_stations',
        androidNotificationChannelName: 'Radio Stations',
        androidStopForegroundOnPause: false,
      ),
    );

    return instance;
  }

  List<MediaControl> _createMediaControls() {
    final mediaControls = <MediaControl>[
      if (_player.playing) MediaControl.pause else MediaControl.play,
    ];
    return mediaControls;
  }

  void _notifyAudioHandlerAboutPlaybackEvents() {
    _player.playbackEventStream.listen((PlaybackEvent event) {
      playbackState.add(
        playbackState.value.copyWith(
          controls: _createMediaControls(),
          systemActions: const {MediaAction.seek},
          androidCompactActionIndices: [0, 1, 2],
          processingState:
              const {
                ProcessingState.idle: AudioProcessingState.idle,
                ProcessingState.loading: AudioProcessingState.loading,
                ProcessingState.buffering: AudioProcessingState.buffering,
                ProcessingState.ready: AudioProcessingState.ready,
                ProcessingState.completed: AudioProcessingState.completed,
              }[_player.processingState]!,
          repeatMode:
              const {
                LoopMode.off: AudioServiceRepeatMode.none,
                LoopMode.one: AudioServiceRepeatMode.one,
                LoopMode.all: AudioServiceRepeatMode.all,
              }[_player.loopMode]!,
          shuffleMode:
              (_player.shuffleModeEnabled)
                  ? AudioServiceShuffleMode.all
                  : AudioServiceShuffleMode.none,
          playing: _player.playing,
          updatePosition: _player.position,
          bufferedPosition: _player.bufferedPosition,
          speed: _player.speed,
          queueIndex: event.currentIndex,
        ),
      );
    });
  }

  @override
  Future<void> addQueueItems(List<MediaItem> mediaItems) async {}

  @override
  Future<void> addQueueItem(MediaItem mediaItem) async {}

  @override
  Future<void> removeQueueItemAt(int index) async {}

  @override
  Future<void> play() async {
    if (_isPreparing) {
      return;
    }
    if (_currentStation != null) {
      await playRadioStation(_currentStation!);
    }
  }

  @override
  Future<void> pause() async {
    if (_isPreparing) {
      return;
    }
    if (_player.playing) {
      await _player.pause();
    } else {
      await _player.play();
    }
  }

  @override
  Future<void> seek(Duration position) async {}

  @override
  Future<void> skipToQueueItem(int index) async {}

  @override
  /// Skip to the next song. It should be called in case of error for trying to
  /// recover the playback.
  Future<void> skipToNext() async {}

  @override
  Future<void> skipToPrevious() async {}

  @override
  Future<void> setRepeatMode(AudioServiceRepeatMode repeatMode) async =>
      _player.setLoopMode(LoopMode.off);

  @override
  Future<void> setShuffleMode(AudioServiceShuffleMode shuffleMode) async =>
      _player.setShuffleModeEnabled(false);

  @override
  Future<void> customAction(String name, [Map<String, dynamic>? extras]) async {
    if (name == 'dispose') {
      await _player.dispose();
      await super.stop();
    }
  }

  /// Returns true if the player is playing
  bool get isPlaying => _player.playing;

  /// Returns the volume of the player
  double get volume => _player.volume;

  /// Set the volume of the player
  Future<void> setVolume(double volume) async => _player.setVolume(volume);

  /// Dispose audio player instance
  Future<void> dispose() async {
    await _player.dispose();
  }

  /// Play a radio station
  ///
  /// [station] is the radio station to play
  Future<void> playRadioStation(RadioStation station) async {
    if (_isPreparing) {
      return;
    }
    try {
      _isPreparing = true;
      await _player.stop();
      await _player.setAudioSource(AudioSource.uri(Uri.parse(station.url)));
      unawaited(_player.play());
      notifyStation(station);
      _isPreparing = false;
      _currentStation = station;
    } catch (e) {
      _isPreparing = false;
      rethrow;
    } finally {
      _isPreparing = false;
    }
  }

  /// Notify the system the current station
  void notifyStation(RadioStation station) {
    mediaItem.add(
      MediaItem(id: station.uuid, title: station.name, artist: station.country),
    );
  }
}
