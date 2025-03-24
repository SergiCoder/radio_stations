import 'package:flutter/material.dart';
import 'package:radio_stations/features/radio/presentation/presentation.dart';

/// A template widget for displaying the loaded state
class RadioLoadedTemplate extends StatelessWidget {
  /// Creates a new instance of [RadioLoadedTemplate]
  const RadioLoadedTemplate({super.key});

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
