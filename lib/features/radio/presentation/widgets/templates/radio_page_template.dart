import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:radio_stations/features/radio/domain/domain.dart';
import 'package:radio_stations/features/radio/presentation/cubit/radio_page_cubit.dart';
import 'package:radio_stations/features/radio/presentation/widgets/atoms/favorite_filter_button.dart';
import 'package:radio_stations/features/radio/presentation/widgets/atoms/radio_station_count.dart';
import 'package:radio_stations/features/radio/presentation/widgets/organisms/radio_player_controls.dart';
import 'package:radio_stations/features/radio/presentation/widgets/organisms/radio_station_list.dart';

/// A template widget for the radio page layout
class RadioPageTemplate extends StatelessWidget {
  /// Creates a new instance of [RadioPageTemplate]
  const RadioPageTemplate({
    required this.stations,
    required this.selectedStation,
    required this.isPlaying,
    required this.showFavorites,
    required this.onStationSelected,
    required this.onPlayPause,
    required this.onPrevious,
    required this.onNext,
    required this.onToggleFavorites,
    required this.onCountryChanged,
    required this.availableCountries,
    required this.selectedCountry,
    super.key,
  });

  /// The list of radio stations to display
  final List<RadioStation> stations;

  /// The currently selected station
  final RadioStation? selectedStation;

  /// Whether the radio is currently playing
  final bool isPlaying;

  /// The current state of the favorite filter
  final bool? showFavorites;

  /// Callback when a station is selected
  final void Function(RadioStation) onStationSelected;

  /// Callback when play/pause is pressed
  final VoidCallback onPlayPause;

  /// Callback when previous is pressed
  final VoidCallback onPrevious;

  /// Callback when next is pressed
  final VoidCallback onNext;

  /// Callback when favorite filter is toggled
  final VoidCallback onToggleFavorites;

  /// Callback when country selection changes
  final void Function(String?) onCountryChanged;

  /// List of available countries
  final List<String> availableCountries;

  /// Currently selected country
  final String? selectedCountry;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Radio Stations'),
        actions: [
          IconButton(
            icon: const Icon(Icons.sync),
            onPressed: () {
              context.read<RadioPageCubit>().loadStations(forceSync: true);
            },
            tooltip: 'Sync stations',
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: RadioStationList(
              stations: stations,
              onStationSelected: onStationSelected,
            ),
          ),
          _buildBottomControlBar(context),
        ],
      ),
    );
  }

  Widget _buildBottomControlBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 200,
                child: DropdownButton<String?>(
                  value: selectedCountry,
                  hint: const Text('All Countries'),
                  isExpanded: true,
                  items: [
                    const DropdownMenuItem<String?>(
                      child: Text('All Countries'),
                    ),
                    ...availableCountries.map(
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
                  onChanged: onCountryChanged,
                ),
              ),
              Row(
                children: [
                  RadioStationCount(count: stations.length),
                  const SizedBox(width: 8),
                  FavoriteFilterButton(
                    showFavorites: showFavorites ?? false,
                    onPressed: onToggleFavorites,
                  ),
                ],
              ),
            ],
          ),
          if (selectedStation != null) ...[
            const SizedBox(height: 8),
            FutureBuilder<RadioStation?>(
              future: context
                  .read<RadioPageCubit>()
                  .getStationByIdUseCase
                  .execute(selectedStation!.uuid),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const SizedBox.shrink();
                }

                final station = snapshot.data!;
                return Row(
                  children: [
                    SizedBox(
                      width: 48,
                      height: 48,
                      child:
                          station.favicon.isNotEmpty
                              ? Image.network(
                                station.favicon,
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
                            station.name,
                            style: Theme.of(context).textTheme.titleMedium,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            isPlaying ? 'Now Playing' : 'Paused',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          if (station.homepage.isNotEmpty) ...[
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(Icons.language, size: 16),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    station.homepage,
                                    style:
                                        Theme.of(context).textTheme.bodySmall,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
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
                          if (station.broken) ...[
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
                );
              },
            ),
            const SizedBox(height: 8),
            RadioPlayerControls(
              isPlaying: isPlaying,
              onPlayPause: onPlayPause,
              onPrevious: onPrevious,
              onNext: onNext,
            ),
          ],
        ],
      ),
    );
  }
}
