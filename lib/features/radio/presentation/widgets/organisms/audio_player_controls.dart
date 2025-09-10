import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:radio_stations/core/design_system/theme/app_sizes.dart';
import 'package:radio_stations/core/design_system/theme/app_spacing.dart';
import 'package:radio_stations/core/utils/input_utils.dart';
import 'package:radio_stations/features/radio/presentation/presentation.dart';

/// A widget that displays radio player controls
class AudioPlayerControls extends StatelessWidget {
  /// Creates a new instance of [AudioPlayerControls]
  const AudioPlayerControls({super.key});

  /// Builds the playback controls row (previous, play/pause, next)
  Widget _buildPlaybackControls(
    BuildContext context,
    bool isPlaying,
    RadioPageBloc bloc,
    ThemeData theme,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: Icon(Icons.skip_previous, color: theme.colorScheme.onSurface),
          onPressed:
              () => InputUtils.unfocusAndThen(
                context,
                () => bloc.add(const PreviousStationRequested()),
              ),
          iconSize: AppSizes.iconLarge,
        ),
        IconButton(
          icon: Icon(
            isPlaying ? Icons.pause : Icons.play_arrow,
            color: theme.colorScheme.onSurface,
          ),
          onPressed:
              () => InputUtils.unfocusAndThen(
                context,
                () => bloc.add(const PlaybackToggled()),
              ),
          iconSize: AppSizes.iconExtraLarge,
        ),
        IconButton(
          icon: Icon(Icons.skip_next, color: theme.colorScheme.onSurface),
          onPressed:
              () => InputUtils.unfocusAndThen(
                context,
                () => bloc.add(const NextStationRequested()),
              ),
          iconSize: AppSizes.iconLarge,
        ),
      ],
    );
  }

  /// Builds the volume controls row
  Widget _buildVolumeControls(
    BuildContext context,
    ThemeData theme,
    double volume,
    RadioPageBloc bloc,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AudioVolumeButton(
            volume: -0.1,
            onPressed: () => bloc.add(const VolumeChanged(-0.1)),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Theme(
              data: theme.copyWith(
                sliderTheme: theme.sliderTheme.copyWith(
                  activeTrackColor: theme.colorScheme.primary,
                  inactiveTrackColor: theme.colorScheme.surfaceContainerHighest,
                  thumbColor: theme.colorScheme.primary,
                ),
              ),
              child: AudioVolumeIndicator(
                value: volume,
                onChanged: (newValue) => bloc.add(VolumeChanged(newValue - volume)),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          AudioVolumeButton(
            volume: 0.1,
            onPressed: () => bloc.add(const VolumeChanged(0.1)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isPlaying = context.select<RadioPageBloc, bool>(
      (bloc) =>
          bloc.state is RadioPageLoaded &&
          (bloc.state as RadioPageLoaded).isPlaying,
    );
    final volume = context.select<RadioPageBloc, double>(
      (bloc) =>
          bloc.state is RadioPageLoaded
              ? (bloc.state as RadioPageLoaded).volume
              : 0.0,
    );
    final bloc = context.read<RadioPageBloc>();
    final theme = Theme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildPlaybackControls(context, isPlaying, bloc, theme),
        _buildVolumeControls(context, theme, volume, bloc),
      ],
    );
  }
}
