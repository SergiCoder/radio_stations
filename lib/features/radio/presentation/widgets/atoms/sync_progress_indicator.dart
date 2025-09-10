import 'package:flutter/material.dart';

/// A widget that displays a sync progress indicator
class SyncProgressIndicator extends StatelessWidget {
  /// Creates a new instance of [SyncProgressIndicator]
  ///
  /// [progressPercentage] is the current progress percentage (0.0 to 1.0)
  const SyncProgressIndicator({
    required this.progressPercentage,
    this.width,
    super.key,
  });

  /// The current progress percentage (0.0 to 1.0)
  final double progressPercentage;

  /// Optional fixed width for the indicator. If null, expands to parent constraints.
  final double? width;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      width: width,
      child: LinearProgressIndicator(
        value: progressPercentage,
        backgroundColor: theme.colorScheme.surface,
        valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
      ),
    );
  }
}
