import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:radio_stations/features/radio/domain/entities/sync_progress.dart';
import 'package:radio_stations/features/radio/presentation/cubit/radio_page_cubit.dart';
import 'package:radio_stations/features/radio/presentation/models/sync_progress_model.dart';
import 'package:radio_stations/features/radio/presentation/state/radio_page_state.dart';
import 'package:radio_stations/features/radio/presentation/widgets/atoms/sync_progress_indicator.dart';
import 'package:radio_stations/features/radio/presentation/widgets/templates/radio_page_template.dart';

/// The main page for the radio application
///
/// This is the main page of the radio stations application. It shows
/// a list of available radio stations and allows the user to browse and
/// interact with them.
class RadioPage extends StatelessWidget {
  /// Creates a new instance of [RadioPage]
  ///
  /// [cubit] is the cubit that manages the state of this page
  const RadioPage({required RadioPageCubit cubit, super.key}) : _cubit = cubit;

  final RadioPageCubit _cubit;

  @override
  Widget build(BuildContext context) {
    _cubit.init();
    return BlocProvider(
      create: (context) => _cubit,
      child: const _RadioPageView(),
    );
  }
}

/// The view component of the RadioPage
///
/// This widget is responsible for displaying the UI based on the current state.
class _RadioPageView extends StatelessWidget {
  /// Creates a new instance of [_RadioPageView]
  const _RadioPageView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RadioPageCubit, RadioPageState>(
      builder: (context, state) {
        if (state is RadioPageSyncProgressState) {
          final syncProgress = SyncProgress(
            totalStations: state.totalStations,
            downloadedStations: state.downloadedStations,
          );
          return SyncProgressIndicator(
            progress: SyncProgressModel.fromEntity(syncProgress),
          );
        }

        if (state is RadioPageErrorState) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Error: ${state.errorMessage}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    context.read<RadioPageCubit>().loadStations();
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        if (state is RadioPageLoadedState) {
          return RadioPageTemplate(
            stations: state.stations,
            onStationSelected: (station) {
              context.read<RadioPageCubit>().selectStation(station);
            },
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
