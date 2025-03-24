import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:radio_stations/features/radio/presentation/cubit/radio_page_cubit.dart';
import 'package:radio_stations/features/radio/presentation/state/radio_page_state.dart';

/// A widget that displays radio player controls
class RadioPlayerControls extends StatelessWidget {
  /// Creates a new instance of [RadioPlayerControls]
  const RadioPlayerControls({super.key});

  @override
  Widget build(BuildContext context) {
    final isPlaying = context.select<RadioPageCubit, bool>(
      (cubit) =>
          cubit.state is RadioPageLoadedState &&
          (cubit.state as RadioPageLoadedState).isPlaying,
    );
    final cubit = context.read<RadioPageCubit>();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        IconButton(
          icon: const Icon(Icons.skip_previous),
          onPressed: cubit.previousStation,
        ),
        IconButton(
          icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
          onPressed: cubit.togglePlayPause,
        ),
        IconButton(
          icon: const Icon(Icons.skip_next),
          onPressed: cubit.nextStation,
        ),
        IconButton(
          icon: const Icon(Icons.volume_up),
          onPressed: () => cubit.setVolume(cubit.volume + 0.1),
        ),
        IconButton(
          icon: const Icon(Icons.volume_down),
          onPressed: () => cubit.setVolume(cubit.volume - 0.1),
        ),
      ],
    );
  }
}
