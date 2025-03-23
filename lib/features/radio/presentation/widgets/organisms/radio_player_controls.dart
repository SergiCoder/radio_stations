import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:radio_stations/features/radio/presentation/cubit/radio_page_cubit.dart';

/// A widget that displays radio player controls
class RadioPlayerControls extends StatelessWidget {
  /// Creates a new instance of [RadioPlayerControls]
  const RadioPlayerControls({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<RadioPageCubit>();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        IconButton(
          icon: const Icon(Icons.skip_previous),
          onPressed: cubit.previousStation,
        ),
        IconButton(
          icon: Icon(cubit.isPlaying ? Icons.pause : Icons.play_arrow),
          onPressed: cubit.togglePlayPause,
        ),
        IconButton(
          icon: const Icon(Icons.skip_next),
          onPressed: cubit.nextStation,
        ),
      ],
    );
  }
}
