import 'package:flutter/material.dart';
import 'package:radio_stations/core/utils/input_utils.dart';

/// A widget that displays a volume indicator with interactive volume adjustment
class AudioVolumeIndicator extends StatelessWidget {
  /// Creates a new instance of [AudioVolumeIndicator]
  const AudioVolumeIndicator({
    required this.value,
    required this.onChanged,
    super.key,
  });

  /// Current volume value (0.0 - 1.0)
  final double value;

  /// Callback when the slider value changes
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    return Slider(
      value: value,
      divisions: 10, // 10% increments
      onChanged: (newValue) {
        InputUtils.unfocusAndThen(context, () => onChanged(newValue));
      },
    );
  }
}
