import 'package:flutter/material.dart';
import 'package:radio_stations/features/radio/domain/domain.dart';
import 'package:radio_stations/features/radio/presentation/widgets/atoms/radio_control_bar.dart';
import 'package:radio_stations/features/radio/presentation/widgets/atoms/radio_page_app_bar.dart';
import 'package:radio_stations/features/radio/presentation/widgets/organisms/radio_station_list.dart';

/// A template widget for the radio page layout
class RadioPageTemplate extends StatelessWidget {
  /// Creates a new instance of [RadioPageTemplate]
  const RadioPageTemplate({
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
    return Scaffold(
      appBar: const RadioPageAppBar(),
      body: Column(
        children: [
          Expanded(
            child: RadioStationList(
              stations: stations,
              onStationSelected: onStationSelected,
            ),
          ),
          const RadioControlBar(),
        ],
      ),
    );
  }
}
