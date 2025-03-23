import 'package:flutter/material.dart';

/// A widget that displays radio player controls
class RadioPlayerControls extends StatelessWidget {
  /// Creates a new instance of [RadioPlayerControls]
  const RadioPlayerControls({
    required this.isPlaying,
    required this.onPlayPause,
    required this.onPrevious,
    required this.onNext,
    super.key,
  });

  /// Whether the radio is currently playing
  final bool isPlaying;

  /// Callback when play/pause is pressed
  final VoidCallback onPlayPause;

  /// Callback when previous is pressed
  final VoidCallback onPrevious;

  /// Callback when next is pressed
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        IconButton(
          icon: const Icon(Icons.skip_previous),
          onPressed: onPrevious,
        ),
        IconButton(
          icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
          onPressed: onPlayPause,
        ),
        IconButton(icon: const Icon(Icons.skip_next), onPressed: onNext),
      ],
    );
  }
}
