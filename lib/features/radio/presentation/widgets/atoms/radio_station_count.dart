import 'package:flutter/material.dart';

/// A simple widget that displays the number of radio stations
class RadioStationCount extends StatelessWidget {
  /// Creates a new instance of [RadioStationCount]
  const RadioStationCount({required this.count, super.key});

  /// The number of stations to display
  final int count;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Text(
        '$count stations',
        style: Theme.of(context).textTheme.bodySmall,
        maxLines: 2,
        overflow: TextOverflow.fade,
        textAlign: TextAlign.center,
      ),
    );
  }
}
