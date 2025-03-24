import 'package:flutter/material.dart';
import 'package:radio_stations/features/radio/presentation/widgets/widgets.dart';

/// A widget that displays the filter controls and station count
class FilterBar extends StatelessWidget {
  /// Creates a new instance of [FilterBar]
  const FilterBar({required this.stationCount, super.key});

  /// The total number of stations
  final int stationCount;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const CountrySelector(),
        RadioStationCount(count: stationCount),
        const FavoriteFilterButton(),
      ],
    );
  }
}
