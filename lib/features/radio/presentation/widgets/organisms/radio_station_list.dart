import 'package:flutter/material.dart';
import 'package:radio_stations/features/radio/domain/entities/radio_station.dart';
import 'package:radio_stations/features/radio/presentation/widgets/molecules/radio_station_list_item.dart';

/// A widget that displays a list of radio stations
class RadioStationList extends StatelessWidget {
  /// Creates a new instance of [RadioStationList]
  const RadioStationList({
    required this.stations,
    required this.onStationSelected,
    super.key,
  });

  /// The list of radio stations to display
  final List<RadioStation> stations;

  /// Callback when a station is selected
  final void Function(RadioStation) onStationSelected;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: stations.length,
      itemBuilder: (context, index) {
        final station = stations[index];
        return RadioStationListItemWidget(
          station: station,
          onTap: () => onStationSelected(station),
        );
      },
    );
  }
}
