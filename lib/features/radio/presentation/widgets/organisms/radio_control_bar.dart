import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:radio_stations/features/radio/presentation/cubit/radio_page_cubit.dart';
import 'package:radio_stations/features/radio/presentation/state/radio_page_state.dart';
import 'package:radio_stations/features/radio/presentation/widgets/atoms/favorite_filter_button.dart';
import 'package:radio_stations/features/radio/presentation/widgets/atoms/radio_station_count.dart';
import 'package:radio_stations/features/radio/presentation/widgets/molecules/radio_station_info.dart';
import 'package:radio_stations/features/radio/presentation/widgets/organisms/radio_player_controls.dart';

/// A widget that displays the bottom control bar for the radio page
class RadioControlBar extends StatelessWidget {
  /// Creates a new instance of [RadioControlBar]
  const RadioControlBar({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<RadioPageCubit>();
    final state = cubit.state as RadioPageLoadedState;
    final countries = state.countries;

    final sixtyPercentWidth = MediaQuery.of(context).size.width * 0.60;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),

      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: sixtyPercentWidth,
                child: DropdownButton<String?>(
                  value: cubit.selectedCountry,
                  hint: const Text('All Countries'),
                  isExpanded: true,
                  items: [
                    const DropdownMenuItem<String?>(
                      child: Text('All Countries'),
                    ),
                    ...countries.map(
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
            RadioStationInfo(station: state.selectedStation!),
            const SizedBox(height: 8),
            const RadioPlayerControls(),
          ] else
            const Text('No station selected'),
        ],
      ),
    );
  }
}
