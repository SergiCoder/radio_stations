import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:radio_stations/features/radio/presentation/cubit/radio_page_cubit.dart';
import 'package:radio_stations/features/radio/presentation/state/radio_page_state.dart';

/// A widget that displays the app bar for the radio page
class RadioPageAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// Creates a new instance of [RadioPageAppBar]
  const RadioPageAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.select<RadioPageCubit, RadioPageState>(
      (cubit) => cubit.state,
    );

    final isLoaded = state is RadioPageLoadedState;

    return AppBar(
      title: const Text('Radio Stations'),
      actions: [
        if (isLoaded)
          IconButton(
            icon: const Icon(Icons.sync),
            onPressed: () {
              context.read<RadioPageCubit>().loadStations(forceSync: true);
            },
            tooltip: 'Sync stations',
          ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
