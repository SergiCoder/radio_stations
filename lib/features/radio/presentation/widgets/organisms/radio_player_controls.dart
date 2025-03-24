import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:radio_stations/core/design_system/theme/app_spacing.dart';
import 'package:radio_stations/core/utils/input_utils.dart';
import 'package:radio_stations/features/radio/presentation/presentation.dart';
import 'package:radio_stations/features/radio/presentation/widgets/molecules/volume_button.dart';

/// A widget that displays radio player controls
class RadioPlayerControls extends StatelessWidget {
  /// Creates a new instance of [RadioPlayerControls]
  const RadioPlayerControls({super.key});

  @override
  Widget build(BuildContext context) {
    final isPlaying = context.select<RadioPageBloc, bool>(
      (bloc) =>
          bloc.state is RadioPageLoaded &&
          (bloc.state as RadioPageLoaded).isPlaying,
    );
    final bloc = context.read<RadioPageBloc>();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Main playback controls (previous, play/pause, next)
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.skip_previous),
              onPressed:
                  () => InputUtils.unfocusAndThen(context, () {
                    bloc.add(const PreviousStationRequested());
                  }),
              iconSize: 32,
            ),
            IconButton(
              icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
              onPressed:
                  () => InputUtils.unfocusAndThen(context, () {
                    bloc.add(const PlaybackToggled());
                  }),
              iconSize: 48,
            ),
            IconButton(
              icon: const Icon(Icons.skip_next),
              onPressed:
                  () => InputUtils.unfocusAndThen(context, () {
                    bloc.add(const NextStationRequested());
                  }),
              iconSize: 32,
            ),
          ],
        ),

        // Volume controls at the bottom
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.sm),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              VolumeButton(volume: -0.1),
              SizedBox(width: AppSpacing.md),
              Expanded(child: VolumeIndicator()),
              SizedBox(width: AppSpacing.md),
              VolumeButton(volume: 0.1),
            ],
          ),
        ),
      ],
    );
  }
}
