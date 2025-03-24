import 'package:flutter/material.dart';
import 'package:radio_stations/features/radio/presentation/widgets/widgets.dart';

/// A widget that displays all filter controls in a single row
class FilterBar extends StatelessWidget {
  /// Creates a new instance of [FilterBar]
  const FilterBar({required this.stationCount, super.key});

  /// The total number of stations
  final int stationCount;

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        // Search field
        Expanded(flex: 3, child: SearchField()),
        SizedBox(width: 8),
        // Country selector
        Expanded(flex: 2, child: CountrySelector()),
        SizedBox(width: 8),
        // Favorite filter
        FavoriteFilterButton(),
      ],
    );
  }
}
