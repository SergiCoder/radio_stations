import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:radio_stations/features/radio/presentation/cubit/radio_page_cubit.dart';

/// A widget that displays a volume indicator
class VolumeIndicator extends StatelessWidget {
  /// Creates a new instance of [VolumeIndicator]
  const VolumeIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    final volume = context.select<RadioPageCubit, double>(
      (cubit) => cubit.volume,
    );

    const height = 24.0;
    final volumeIndicatorHeight = height * volume;

    return Container(
      width: 2,
      height: height,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      color: Theme.of(context).colorScheme.surface,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            width: 2,
            height: volumeIndicatorHeight,
            color: Theme.of(context).colorScheme.primary,
          ),
        ],
      ),
    );
  }
}
