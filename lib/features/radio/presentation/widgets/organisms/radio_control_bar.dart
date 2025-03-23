import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:radio_stations/features/radio/presentation/cubit/radio_page_cubit.dart';
import 'package:radio_stations/features/radio/presentation/state/radio_page_state.dart';
import 'package:radio_stations/features/radio/presentation/widgets/atoms/favorite_filter_button.dart';
import 'package:radio_stations/features/radio/presentation/widgets/atoms/radio_station_count.dart';
import 'package:radio_stations/features/radio/presentation/widgets/organisms/radio_player_controls.dart';
import 'package:url_launcher/url_launcher.dart';

/// A widget that displays the bottom control bar for the radio page
class RadioControlBar extends StatelessWidget {
  /// Creates a new instance of [RadioControlBar]
  const RadioControlBar({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<RadioPageCubit>();
    final state = cubit.state as RadioPageLoadedState;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),

      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 200,
                child: DropdownButton<String?>(
                  value: cubit.selectedCountry,
                  hint: const Text('All Countries'),
                  isExpanded: true,
                  items: [
                    const DropdownMenuItem<String?>(
                      child: Text('All Countries'),
                    ),
                    ...cubit.countries.map(
                      (country) => DropdownMenuItem<String>(
                        value: country,
                        child: Text(
                          country.length > 20
                              ? '${country.substring(0, 20)}...'
                              : country,
                          overflow: TextOverflow.fade,
                        ),
                      ),
                    ),
                  ],
                  onChanged: cubit.setSelectedCountry,
                ),
              ),
              RadioStationCount(count: state.stations.length),
              const FavoriteFilterButton(),
            ],
          ),
          if (state.selectedStation != null) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                SizedBox(
                  width: 48,
                  height: 48,
                  child:
                      state.selectedStation!.favicon.isNotEmpty
                          ? Image.network(
                            state.selectedStation!.favicon,
                            errorBuilder:
                                (context, error, stackTrace) =>
                                    const Icon(Icons.radio, size: 48),
                          )
                          : const Icon(Icons.radio, size: 48),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        state.selectedStation!.name,
                        style: Theme.of(context).textTheme.titleMedium,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (state.selectedStation!.homepage.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        GestureDetector(
                          onTap:
                              () => launchUrl(
                                Uri.parse(state.selectedStation!.homepage),
                              ),
                          child: Row(
                            children: [
                              const Icon(Icons.language, size: 16),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  state.selectedStation!.homepage,
                                  style: Theme.of(context).textTheme.bodySmall,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                      if (state.selectedStation!.country.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.location_on, size: 16),
                            const SizedBox(width: 4),
                            Text(
                              state.selectedStation!.country,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ],
                      if (state.selectedStation!.broken) ...[
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.error_outline, size: 16),
                            const SizedBox(width: 4),
                            Text(
                              'Station is broken',
                              style: Theme.of(
                                context,
                              ).textTheme.bodySmall?.copyWith(
                                color: Theme.of(context).colorScheme.error,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const RadioPlayerControls(),
          ],
        ],
      ),
    );
  }
}
