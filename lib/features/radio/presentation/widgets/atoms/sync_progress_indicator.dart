import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:radio_stations/features/radio/presentation/cubit/radio_page_cubit.dart';
import 'package:radio_stations/features/radio/presentation/state/radio_page_state.dart';

/// A widget that displays a sync progress indicator
class SyncProgressIndicator extends StatelessWidget {
  /// Creates a new instance of [SyncProgressIndicator]
  const SyncProgressIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    final halfWidth = MediaQuery.of(context).size.width * 0.5;
    final state = context.select<RadioPageCubit, RadioPageState>(
      (cubit) => cubit.state,
    );

    if (state is! RadioPageSyncProgressState) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      width: halfWidth,
      child: LinearProgressIndicator(
        value: state.syncProgress.progress,
        backgroundColor: Theme.of(context).colorScheme.surface,
        valueColor: AlwaysStoppedAnimation<Color>(
          Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}
