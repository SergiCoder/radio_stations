import 'package:flutter/material.dart';
import 'package:radio_stations/core/utils/ui_utils.dart';

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
    final theme = Theme.of(context);
    final indicatorWidth = UIUtils.getMediumWidth(context);

    return SizedBox(
      width: indicatorWidth,
      child: LinearProgressIndicator(
        value: progressPercentage,
        backgroundColor: theme.colorScheme.surface,
        valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
      ),
    );
  }
}
