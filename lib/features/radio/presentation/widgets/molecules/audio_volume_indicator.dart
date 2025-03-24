import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:radio_stations/core/utils/input_utils.dart';
import 'package:radio_stations/features/radio/presentation/bloc/bloc.dart';

/// A widget that displays a volume indicator with interactive volume adjustment
class AudioVolumeIndicator extends StatelessWidget {
  /// Creates a new instance of [AudioVolumeIndicator]
  const AudioVolumeIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.select<RadioPageBloc, RadioPageState>(
      (bloc) => bloc.state,
    );

    if (state is! RadioPageLoaded) {
      return const SizedBox.shrink();
    }

    final volume = state.volume;
    final bloc = context.read<RadioPageBloc>();

    return Slider(
      value: volume,
      divisions: 10, // 10% increments
      onChanged: (newValue) {
        InputUtils.unfocusAndThen(context, () {
          // Send the direct volume value rather than calculating delta
          bloc.add(VolumeChanged(newValue - volume));
        });
      },
    );
  }
}
