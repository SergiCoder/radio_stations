import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:radio_stations/features/radio/presentation/cubit/radio_page_cubit.dart';
import 'package:radio_stations/features/radio/presentation/state/radio_page_state.dart';
import 'package:radio_stations/features/radio/presentation/widgets/molecules/radio_station_list_item.dart';

/// A widget that displays a list of radio stations
class RadioStationList extends StatelessWidget {
  /// Creates a new instance of [RadioStationList]
  const RadioStationList({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<RadioPageCubit>();
    final state = cubit.state as RadioPageLoadedState;

    if (state.stations.isEmpty) {
      return const Center(child: Text('No stations found, try to sync again'));
    }

    return ListView.builder(
      itemCount: state.stations.length,
      itemBuilder: (context, index) {
        final station = state.stations[index];
        return RadioStationListItemWidget(
          station: station,
          onTap: () => cubit.selectStation(station),
        );
      },
    );
  }
}
