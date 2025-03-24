import 'package:flutter/material.dart';
import 'package:radio_stations/core/constants/app_constants.dart';
import 'package:radio_stations/core/utils/input_utils.dart';

/// A widget that displays a dropdown menu for selecting a country
class FilterCountrySelector extends StatelessWidget {
  /// Creates a new instance of [FilterCountrySelector]
  ///
  /// [selectedCountry] is the currently selected country, or null for all countries
  /// [countries] is the list of available countries to select from
  /// [onChanged] is called when a country is selected
  const FilterCountrySelector({
    required this.selectedCountry,
    required this.countries,
    required this.onChanged,
    super.key,
  });

  /// Currently selected country, or null for all countries
  final String? selectedCountry;

  /// List of available countries to select from
  final List<String> countries;

  /// Callback when country selection changes
  final void Function(String?) onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String?>(
      value: selectedCountry,
      hint: const Text('All Countries'),
      isExpanded: true,
      items: [
        const DropdownMenuItem<String?>(child: Text('All Countries')),
        ...countries.map(
          (country) => DropdownMenuItem<String>(
            value: country,
            child: Text(
              country.length > AppConstants.maxDropdownItemLength
                  ? '${country.substring(0, AppConstants.maxDropdownItemLength)}...'
                  : country,
              overflow: TextOverflow.fade,
            ),
          ),
        ),
      ],
      onChanged: (country) {
        // Unfocus before selecting country
        InputUtils.unfocusAndThen(context, () {
          onChanged(country);
        });
      },
    );
  }
}
