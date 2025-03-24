import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:radio_stations/features/radio/presentation/bloc/radio_page_bloc.dart';
import 'package:radio_stations/features/radio/presentation/bloc/radio_page_events.dart';
import 'package:radio_stations/features/radio/presentation/bloc/radio_page_states.dart';

/// A widget that displays a dropdown menu for selecting a country
class CountrySelector extends StatelessWidget {
  /// Creates a new instance of [CountrySelector]
  const CountrySelector({super.key});

  @override
  Widget build(BuildContext context) {
    // Select the state from the bloc
    final state = context.select<RadioPageBloc, RadioPageState>(
      (bloc) => bloc.state,
    );

    if (state is! RadioPageLoaded) {
      return const SizedBox.shrink();
    }

    final selectedCountry = state.selectedFilter.country;
    final countries = state.countries;
    final sixtyPercentWidth = MediaQuery.of(context).size.width * 0.6;

    return SizedBox(
      width: sixtyPercentWidth,
      child: DropdownButton<String?>(
        value: selectedCountry,
        hint: const Text('All Countries'),
        isExpanded: true,
        items: [
          const DropdownMenuItem<String?>(child: Text('All Countries')),
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
        onChanged: (country) {
          context.read<RadioPageBloc>().add(CountrySelected(country));
        },
      ),
    );
  }
}
