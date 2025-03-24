import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:radio_stations/core/utils/input_utils.dart';
import 'package:radio_stations/features/radio/presentation/bloc/bloc.dart';

/// A button that allows the user to adjust the volume of the radio
class VolumeButton extends StatelessWidget {
  /// Creates a new instance of [VolumeButton]
  const VolumeButton({required this.volume, super.key});

  /// The bloc that manages the radio page
  final double volume;

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<RadioPageBloc>();

    void onPressed() => InputUtils.unfocusAndThen(context, () {
      bloc.add(VolumeChanged(volume));
    });

    return SizedBox(
      width: 30,
      height: 30,
      child: IconButton(
        padding: EdgeInsets.zero,
        iconSize: 24,
        icon: const Icon(Icons.volume_down),
        onPressed: onPressed,
      ),
    );
  }
}
