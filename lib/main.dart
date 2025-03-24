import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:radio_stations/core/design_system/theme/app_theme.dart';
import 'package:radio_stations/core/di/injection.dart';
import 'package:radio_stations/features/audio/domain/repositories/audio_repository.dart';
import 'package:radio_stations/features/radio/radio.dart';
import 'package:radio_stations/features/shared/domain/events/error_event_bus.dart';

/// The main entry point of the application
void main() async {
  await runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      // Initialize dependencies
      await init();

      // Register a callback to be called when the app is shutting down
      // This ensures resources are properly disposed
      SystemChannels.lifecycle.setMessageHandler((message) async {
        log('Lifecycle message: $message');
        if (message == AppLifecycleState.detached.toString()) {
          await _disposeResources();
        }
        return null;
      });

      runApp(const MyApp());
    },
    (error, stackTrace) {
      log(
        'An error occurred:',
        error: error,
        stackTrace: stackTrace,
        name: 'main',
      );
    },
  );
}

/// Disposes resources when the app is shutting down
Future<void> _disposeResources() async {
  log('Disposing resources...');
  try {
    // Dispose the AudioRepository which will dispose the AudioServiceImpl
    await getIt<AudioRepository>().dispose();

    // Dispose the RadioStationRepository which will:
    // - Close the HTTP client in the remote data source
    // - Close the Hive box through the local data source
    await getIt<RadioStationRepository>().dispose();

    // Dispose the ErrorEventBus
    getIt<ErrorEventBus>().dispose();

    log('Resources disposed successfully');
  } catch (e, stackTrace) {
    log(
      'Error disposing resources:',
      error: e,
      stackTrace: stackTrace,
      name: 'dispose',
    );
  }
}

/// The root widget of the application
///
/// This widget configures the app's theme and displays the main radio page.
class MyApp extends StatelessWidget {
  /// Creates a new instance of [MyApp]
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Radio Stations',
      theme: AppTheme.darkTheme,
      home: RadioPage(bloc: getIt()),
    );
  }
}
