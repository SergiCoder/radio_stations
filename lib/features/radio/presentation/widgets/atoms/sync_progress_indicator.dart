import 'package:flutter/material.dart';

/// A widget that displays a sync progress indicator
class SyncProgressIndicator extends StatelessWidget {
  /// Creates a new instance of [SyncProgressIndicator]
  ///
  /// [progressPercentage] is the current progress percentage (0.0 to 1.0)
  const SyncProgressIndicator({required this.progressPercentage, super.key});

  /// The current progress percentage (0.0 to 1.0)
  final double progressPercentage;

  @override
  Widget build(BuildContext context) {
    final halfWidth = MediaQuery.of(context).size.width * 0.5;

    return SizedBox(
      width: halfWidth,
      child: LinearProgressIndicator(
        value: progressPercentage,
        backgroundColor: Theme.of(context).colorScheme.surface,
        valueColor: AlwaysStoppedAnimation<Color>(
          Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}
