import 'package:flutter/material.dart';
import 'package:radio_stations/features/radio/presentation/models/sync_progress_model.dart';

/// A widget that displays the progress of a synchronization operation
class SyncProgressIndicator extends StatelessWidget {
  /// Creates a new instance of [SyncProgressIndicator]
  const SyncProgressIndicator({
    required this.progress,
    super.key,
  });

  /// The sync progress model
  final SyncProgressModel progress;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Syncing stations...',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            progress.progressMessage,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: 200,
            child: LinearProgressIndicator(
              value: progress.progressValue,
              backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
              valueColor: AlwaysStoppedAnimation<Color>(
                Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
