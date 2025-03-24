import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:radio_stations/core/design_system/theme/app_sizes.dart';
import 'package:radio_stations/core/utils/input_utils.dart';
import 'package:radio_stations/features/radio/presentation/bloc/bloc.dart';

/// A button that allows the user to adjust the volume of the radio
class AudioVolumeButton extends StatelessWidget {
  /// Creates a new instance of [AudioVolumeButton]
  const AudioVolumeButton({required this.volume, super.key});

  /// The volume adjustment value (-0.1 or 0.1)
  final double volume;

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<RadioPageBloc>();

    // Use volume_up icon for increasing volume, volume_down for decreasing
    final iconData = volume > 0 ? Icons.volume_up : Icons.volume_down;

    return SizedBox(
      width: AppSizes.iconButtonSize,
      height: AppSizes.iconButtonSize,
      child: IconButton(
        padding: EdgeInsets.zero,
        iconSize: AppSizes.iconMedium,
        icon: Icon(iconData),
        onPressed:
            () => InputUtils.unfocusAndThen(
              context,
              () => bloc.add(VolumeChanged(volume)),
            ),
      ),
    );
  }
}
