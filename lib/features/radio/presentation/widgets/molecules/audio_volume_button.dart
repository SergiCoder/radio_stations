import 'package:flutter/material.dart';
import 'package:radio_stations/core/design_system/theme/app_sizes.dart';
import 'package:radio_stations/core/utils/input_utils.dart';

/// A button that allows the user to adjust the volume of the radio
class AudioVolumeButton extends StatelessWidget {
  /// Creates a new instance of [AudioVolumeButton]
  const AudioVolumeButton({
    required this.volume,
    required this.onPressed,
    super.key,
  });

  /// The volume adjustment value (-0.1 or 0.1)
  final double volume;

  /// Callback when the button is pressed
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    // Use volume_up icon for increasing volume, volume_down for decreasing
    final iconData = volume > 0 ? Icons.volume_up : Icons.volume_down;

    return SizedBox(
      width: AppSizes.iconButtonSize,
      height: AppSizes.iconButtonSize,
      child: IconButton(
        padding: EdgeInsets.zero,
        iconSize: AppSizes.iconMedium,
        icon: Icon(iconData),
        onPressed: () => InputUtils.unfocusAndThen(context, onPressed),
      ),
    );
  }
}
