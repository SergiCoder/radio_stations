import 'package:get_it/get_it.dart';
import 'package:hive_ce/hive.dart';
import 'package:http/http.dart' as http;
import 'package:just_audio/just_audio.dart';
// Core imports
import 'package:radio_stations/core/database/hive_database.dart';
import 'package:radio_stations/core/utils/validators.dart';
// Feature imports - each barrel contains all components for that feature
import 'package:radio_stations/features/audio/audio.dart';
import 'package:radio_stations/features/radio/radio.dart';
import 'package:radio_stations/features/shared/shared.dart';
// Feature API imports - public interfaces used across features
// Feature implementation imports - only needed in DI

/// Global service locator instance
///
/// This singleton instance of [GetIt] is used throughout the application
/// to manage and resolve dependencies. It provides a centralized way to
/// access services, repositories, and other dependencies.
final getIt = GetIt.instance;

/// Initializes all dependencies for the application
///
/// This function is called at app startup to register all services,
/// repositories, and other dependencies with the service locator.
Future<void> init() async {
  // Register database
  final database = await HiveDatabase.create();
  getIt.registerLazySingleton<Database>(() => database);
  final radioStationBox = await database.init();

  // Register core services
  getIt
    ..registerLazySingleton<ValidationService>(() => const Validators())
    ..registerLazySingleton<ErrorEventBus>(ErrorEventBus.new);

  final player = AudioPlayer();

  final audioService = await AudioServiceImpl.initAudioService(
    player: player,
    errorEventBus: getIt(),
  );

  // Core
  getIt
    ..registerLazySingleton<http.Client>(http.Client.new)
    ..registerLazySingleton<RadioBrowserConfig>(RadioBrowserConfig.new)
    // Database
    ..registerLazySingleton<Box<RadioStationLocalDto>>(() => radioStationBox)
    // Data sources
    ..registerLazySingleton<RadioStationRemoteDataSource>(
      () => RadioStationRemoteDataSource(client: getIt(), config: getIt()),
    )
    ..registerLazySingleton<RadioStationLocalDataSource>(
      () => RadioStationLocalDataSource(box: getIt()),
    )
    ..registerLazySingleton<RadioStationMapper>(
      () => RadioStationMapper(validationService: getIt()),
    )
    // Repositories
    ..registerLazySingleton<AudioRepository>(
      () => AudioRepositoryImpl(audioService: getIt()),
    )
    ..registerLazySingleton<RadioStationRepository>(
      () => RadioStationRepositoryImpl(
        localDataSource: getIt(),
        remoteDataSource: getIt(),
        mapper: getIt(),
      ),
    )
    // Audio
    ..registerLazySingleton<AudioPlayer>(() => player)
    ..registerLazySingleton<AudioServiceImpl>(() => audioService)
    // Use cases
    ..registerLazySingleton<GetRadioStationListUseCase>(
      () => GetRadioStationListUseCase(radioStationRepository: getIt()),
    )
    ..registerLazySingleton<SyncRadioStationsUseCase>(
      () => SyncRadioStationsUseCase(radioStationRepository: getIt()),
    )
    ..registerLazySingleton<PlayRadioStationUseCase>(
      () => PlayRadioStationUseCase(
        radioStationRepository: getIt(),
        audioRepository: getIt(),
      ),
    )
    ..registerLazySingleton<ToggleFavoriteRadioStationUseCase>(
      () => ToggleFavoriteRadioStationUseCase(radioStationRepository: getIt()),
    )
    ..registerLazySingleton<GetPlaybackStateUseCase>(
      () => GetPlaybackStateUseCase(audioRepository: getIt()),
    )
    ..registerLazySingleton<TogglePlayPauseUseCase>(
      () => TogglePlayPauseUseCase(audioRepository: getIt()),
    )
    ..registerLazySingleton<SetBrokenRadioStationUseCase>(
      () => SetBrokenRadioStationUseCase(radioStationRepository: getIt()),
    )
    ..registerLazySingleton<SetVolumeUseCase>(
      () => SetVolumeUseCase(audioRepository: getIt()),
    )
    ..registerLazySingleton<GetVolumeStreamUseCase>(
      () => GetVolumeStreamUseCase(repository: getIt()),
    )
    // BLoC
    ..registerFactory<RadioPageBloc>(
      () => RadioPageBloc(
        getRadioStationListUseCase: getIt(),
        syncStationsUseCase: getIt(),
        playRadioStationUseCase: getIt(),
        toggleFavoriteUseCase: getIt(),
        getPlaybackStateUseCase: getIt(),
        togglePlayPauseUseCase: getIt(),
        setBrokenRadioStationUseCase: getIt(),
        setVolumeUseCase: getIt(),
        getVolumeStreamUseCase: getIt(),
        errorEventBus: getIt(),
      ),
    );
}
