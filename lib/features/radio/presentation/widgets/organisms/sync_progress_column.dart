import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:radio_stations/features/radio/presentation/presentation.dart';
import 'package:radio_stations/features/radio/presentation/widgets/atoms/sync_progress_indicator.dart';

/// A widget that displays the progress of a synchronization operation
class SyncProgressColumn extends StatelessWidget {
  /// Creates a new instance of [SyncProgressColumn]
  const SyncProgressColumn({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.select<RadioPageCubit, RadioPageState>(
      (cubit) => cubit.state,
    );

    if (state is! RadioPageSyncProgressState) {
      return const SizedBox.shrink();
    }

    final progress = state.syncProgress;

    /// Gets the progress message to display
    final progressMessage =
        '${progress.downloadedStations} of ${progress.totalStations} stations';

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const Spacer(flex: 20),
          Text(
            'Syncing stations...',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const Spacer(flex: 2),
          Text(
            progressMessage,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const Spacer(flex: 3),
          const SyncProgressIndicator(),
          const Spacer(flex: 20),
        ],
      ),
    );
  }
}
