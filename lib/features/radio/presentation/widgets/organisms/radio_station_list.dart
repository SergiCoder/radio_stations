import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:radio_stations/features/radio/presentation/presentation.dart';
import 'package:radio_stations/features/shared/domain/entitites/radio_station.dart';

/// A widget that displays a list of radio stations
class RadioStationList extends StatelessWidget {
  /// Creates a new instance of [RadioStationList]
  const RadioStationList({super.key});

  @override
  Widget build(BuildContext context) {
    final stations = context.select<RadioPageBloc, List<RadioStation>>(
      (bloc) =>
          bloc.state is RadioPageLoaded
              ? (bloc.state as RadioPageLoaded).stations
              : const [],
    );

    final isLoaded = context.select<RadioPageBloc, bool>(
      (bloc) => bloc.state is RadioPageLoaded,
    );

    if (!isLoaded) {
      return const SizedBox.shrink();
    }

    if (stations.isEmpty) {
      return const Center(
        child: Text(
          'No stations found,\n maybe try to sync?',
          textAlign: TextAlign.center,
          maxLines: 2,
        ),
      );
    }

    return ListView.builder(
      itemCount: stations.length,
      itemBuilder: (context, index) {
        final station = stations[index];
        return RadioStationListItem(
          station: station,
          onTap:
              () => context.read<RadioPageBloc>().add(
                RadioStationSelected(station),
              ),
        );
      },
    );
  }
}
