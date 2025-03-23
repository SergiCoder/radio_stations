import 'package:flutter/material.dart';
import 'package:radio_stations/features/radio/presentation/models/sync_progress_model.dart';

/// A widget that displays the progress of a synchronization operation
class SyncProgressIndicator extends StatelessWidget {
  /// Creates a new instance of [SyncProgressIndicator]
  const SyncProgressIndicator({required this.progress, super.key});

  /// The sync progress model
  final SyncProgressModel progress;

  @override
  Widget build(BuildContext context) {
    final halfWidth = MediaQuery.of(context).size.width / 2;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const Spacer(flex: 20),
          Text(
            'Syncing stations...',
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          const Spacer(flex: 2),
          Text(
            progress.progressMessage,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const Spacer(flex: 3),
          SizedBox(
            width: halfWidth,
            child: LinearProgressIndicator(
              value: progress.progressValue,
              backgroundColor: Theme.of(context).colorScheme.surface,
              valueColor: AlwaysStoppedAnimation<Color>(
                Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          const Spacer(flex: 20),
        ],
      ),
    );
  }
}
