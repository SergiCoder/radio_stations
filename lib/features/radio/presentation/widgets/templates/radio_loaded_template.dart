import 'package:flutter/material.dart';
import 'package:radio_stations/features/radio/domain/domain.dart';
import 'package:radio_stations/features/radio/presentation/widgets/atoms/radio_page_app_bar.dart';
import 'package:radio_stations/features/radio/presentation/widgets/organisms/radio_control_bar.dart';
import 'package:radio_stations/features/radio/presentation/widgets/organisms/radio_station_list.dart';

/// A template widget for displaying the loaded state
class RadioLoadedTemplate extends StatelessWidget {
  /// Creates a new instance of [RadioLoadedTemplate]
  const RadioLoadedTemplate({required this.stations, super.key});

  /// The list of radio stations to display
  final List<RadioStation> stations;

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: RadioPageAppBar(),
      body: Column(
        children: [Expanded(child: RadioStationList()), RadioControlBar()],
      ),
    );
  }
}
