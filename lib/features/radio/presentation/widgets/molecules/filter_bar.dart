import 'package:flutter/material.dart';
import 'package:radio_stations/core/design_system/theme/app_spacing.dart';
import 'package:radio_stations/features/radio/presentation/widgets/widgets.dart';

/// A widget that displays all filter controls in a single row
class FilterBar extends StatelessWidget {
  /// Creates a new instance of [FilterBar]
  const FilterBar({
    required this.stationCount,
    required this.showFavorites,
    required this.onFavoriteToggle,
    required this.onSearchChanged,
    required this.onCountrySelected,
    required this.selectedCountry,
    required this.countries,
    required this.searchTerm,
    super.key,
  });

  /// The total number of stations
  final int stationCount;

  /// Whether to show only favorites
  final bool showFavorites;

  /// Callback when favorite filter is toggled
  final VoidCallback onFavoriteToggle;

  /// Callback when search term changes
  final void Function(String) onSearchChanged;

  /// Callback when country is selected
  final void Function(String?) onCountrySelected;

  /// Currently selected country
  final String? selectedCountry;

  /// List of available countries
  final List<String> countries;

  /// Current search term
  final String searchTerm;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Search field
        Expanded(
          flex: 3,
          child: FilterSearchField(
            searchTerm: searchTerm,
            onChanged: onSearchChanged,
          ),
        ),
        SizedBox(width: AppSpacing.sm),
        // Country selector
        Expanded(
          flex: 2,
          child: FilterCountrySelector(
            selectedCountry: selectedCountry,
            countries: countries,
            onCountrySelected: onCountrySelected,
          ),
        ),
        SizedBox(width: AppSpacing.sm),
        // Favorite filter
        FilterFavoriteButton(
          showFavorites: showFavorites,
          onToggle: onFavoriteToggle,
        ),
      ],
    );
  }
}
