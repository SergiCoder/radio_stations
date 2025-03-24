import 'package:flutter/material.dart';
import 'package:radio_stations/features/shared/domain/entitites/radio_station.dart';
import 'package:url_launcher/url_launcher.dart';

/// A widget that displays information about a radio station
class RadioStationInfo extends StatelessWidget {
  /// Creates a new instance of [RadioStationInfo]
  const RadioStationInfo({required this.station, super.key});

  /// The radio station to display information about
  final RadioStation station;

  @override
  Widget build(BuildContext context) {
    final twentyPercentWidth = MediaQuery.of(context).size.width * 0.20;
    return Card(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: SizedBox(
              width: twentyPercentWidth,
              height: twentyPercentWidth,
              child:
                  station.broken
                      ? Icon(Icons.error_outline, color: Colors.red.shade300)
                      : station.favicon.isNotEmpty
                      ? Image.network(
                        station.favicon,
                        errorBuilder:
                            (context, error, stackTrace) =>
                                const Icon(Icons.radio),
                      )
                      : const Icon(Icons.radio),
            ),
          ),
          const Spacer(),
          Expanded(
            flex: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        station.name,
                        style: Theme.of(context).textTheme.titleMedium,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                if (station.homepage.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  GestureDetector(
                    onTap: () => launchUrl(Uri.parse(station.homepage)),
                    child: Row(
                      children: [
                        const Icon(Icons.language, size: 16),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            station.homepage,
                            style: Theme.of(context).textTheme.bodySmall,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                if (station.country.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        station.country,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
