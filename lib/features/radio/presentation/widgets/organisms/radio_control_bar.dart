import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:radio_stations/features/radio/presentation/presentation.dart';

/// A widget that displays the bottom control bar for the radio page
class RadioControlBar extends StatelessWidget {
  /// Creates a new instance of [RadioControlBar]
  const RadioControlBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RadioPageBloc, RadioPageState>(
      builder: (context, state) {
        if (state is! RadioPageLoaded) {
          return const SizedBox.shrink();
        }

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FilterBar(stationCount: state.stations.length),
              if (state.selectedStation != null)
                PlayerBar(station: state.selectedStation!)
              else
                const Text('No station selected'),
            ],
          ),
        );
      },
    );
  }
}
