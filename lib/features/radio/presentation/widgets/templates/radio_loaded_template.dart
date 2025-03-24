import 'package:flutter/material.dart';
import 'package:radio_stations/features/radio/presentation/presentation.dart';

/// A template widget for displaying the loaded state
class RadioLoadedTemplate extends StatelessWidget {
  /// Creates a new instance of [RadioLoadedTemplate]
  const RadioLoadedTemplate({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // Unfocus when tapping anywhere outside interactive elements
      onTap: () => FocusScope.of(context).unfocus(),
      // This is critical - it allows the detector to handle taps that weren't handled by children
      behavior: HitTestBehavior.translucent,
      child: const Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: RadioPageAppBar(),
        body: Column(
          children: [
            RadioPageHeader(),
            Expanded(child: RadioStationList()),
            RadioControlBar(),
          ],
        ),
      ),
    );
  }
}
