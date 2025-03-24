import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:radio_stations/core/design_system/theme/theme.dart';
import 'package:radio_stations/features/radio/presentation/bloc/bloc.dart';

/// A widget that displays the app bar for the radio page
class RadioPageAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// Creates a new instance of [RadioPageAppBar]
  const RadioPageAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.select<RadioPageBloc, RadioPageState>(
      (bloc) => bloc.state,
    );

    final isLoaded = state is RadioPageLoaded;
    final stationCount = isLoaded ? state.stations.length : 0;

    return AppBar(
      backgroundColor: AppColors.background,
      scrolledUnderElevation: 0,
      title: Text('Radio Stations: $stationCount listed'),
      actions: [
        if (isLoaded)
          IconButton(
            icon: const Icon(Icons.sync),
            onPressed: () {
              context.read<RadioPageBloc>().add(
                const RadioStationsRequested(forceSync: true),
              );
            },
            tooltip: 'Sync stations',
          ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
