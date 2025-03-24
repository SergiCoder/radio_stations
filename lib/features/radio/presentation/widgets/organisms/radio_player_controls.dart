import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:radio_stations/features/radio/presentation/bloc/radio_page_bloc.dart';
import 'package:radio_stations/features/radio/presentation/bloc/radio_page_events.dart';
import 'package:radio_stations/features/radio/presentation/bloc/radio_page_states.dart';
import 'package:radio_stations/features/radio/presentation/widgets/molecules/volume_indicator.dart';

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

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        IconButton(
          icon: const Icon(Icons.skip_previous),
          onPressed: () => bloc.add(const PreviousStationRequested()),
        ),
        IconButton(
          icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
          onPressed: () => bloc.add(const PlaybackToggled()),
        ),
        IconButton(
          icon: const Icon(Icons.skip_next),
          onPressed: () => bloc.add(const NextStationRequested()),
        ),
        IconButton(
          icon: const Icon(Icons.volume_up),
          onPressed: () => bloc.add(const VolumeChanged(0.1)),
        ),
        IconButton(
          icon: const Icon(Icons.volume_down),
          onPressed: () => bloc.add(const VolumeChanged(-0.1)),
        ),
        const VolumeIndicator(),
      ],
    );
  }
}
