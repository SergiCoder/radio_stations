import 'package:get_it/get_it.dart';
import 'package:hive_ce/hive.dart';
import 'package:http/http.dart' as http;
import 'package:just_audio/just_audio.dart';
import 'package:radio_stations/core/database/hive_database.dart';
import 'package:radio_stations/features/radio/data/datasources/datasources.dart';
import 'package:radio_stations/features/radio/data/dto/radio_station_local_dto.dart';
import 'package:radio_stations/features/radio/data/repositories/audio_repository_impl.dart';
import 'package:radio_stations/features/radio/data/repositories/radio_station_repository_impl.dart';
import 'package:radio_stations/features/radio/data/services/audio_service_impl.dart';
import 'package:radio_stations/features/radio/domain/domain.dart';
import 'package:radio_stations/features/radio/domain/repositories/audio_repository.dart';
import 'package:radio_stations/features/radio/domain/use_cases/toggle_favorite_radio_station_use_case.dart';
import 'package:radio_stations/features/radio/presentation/cubit/radio_page_cubit.dart';

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
  final radioStationBox = await HiveDatabase.init();
  final player = AudioPlayer();
  final audioService = await AudioServiceImpl.initAudioService(player: player);

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

    // Repositories
    ..registerLazySingleton<RadioStationRepository>(
      () => RadioStationRepositoryImpl(
        remoteDataSource: getIt(),
        localDataSource: getIt(),
      ),
    )

    // Audio
    ..registerLazySingleton<AudioPlayer>(() => player)
    ..registerLazySingleton<AudioServiceImpl>(() => audioService)
    ..registerLazySingleton<AudioRepository>(
      () => AudioRepositoryImpl(audioService: getIt()),
    )

    // Use cases
    ..registerLazySingleton<GetAllRadioStationListItemsUseCase>(
      () => GetAllRadioStationListItemsUseCase(repository: getIt()),
    )
    ..registerLazySingleton<GetRadioStationByIdUseCase>(
      () => GetRadioStationByIdUseCase(
        repository: getIt(),
        audioRepository: getIt(),
      ),
    )
    ..registerLazySingleton<SyncRadioStationsUseCase>(
      () => SyncRadioStationsUseCase(repository: getIt()),
    )
    ..registerLazySingleton<ToggleFavoriteRadioStationUseCase>(
      () => ToggleFavoriteRadioStationUseCase(repository: getIt()),
    )

    // Cubits
    ..registerFactory<RadioPageCubit>(
      () => RadioPageCubit(
        getAllStationsUseCase: getIt(),
        syncStationsUseCase: getIt(),
        getStationByIdUseCase: getIt(),
        toggleFavoriteUseCase: getIt(),
      ),
    );
}
