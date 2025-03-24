import 'package:flutter/material.dart';
import 'package:radio_stations/core/design_system/theme/app_spacing.dart';
import 'package:radio_stations/features/radio/presentation/widgets/widgets.dart';

/// A widget that displays all filter controls in a single row
class FilterBar extends StatelessWidget {
  /// Creates a new instance of [FilterBar]
  const FilterBar({
    required this.stationCount,
    required this.showFavorites,
    required this.selectedCountry,
    required this.countries,
    required this.searchTerm,
    required this.onFavoriteToggled,
    required this.onSearchTermChanged,
    required this.onCountryChanged,
    super.key,
  });

  /// The total number of stations
  final int stationCount;

  /// Whether to show only favorites
  final bool showFavorites;

  /// Currently selected country
  final String? selectedCountry;

  /// List of available countries
  final List<String> countries;

  /// Current search term
  final String searchTerm;

  /// Callback when favorite filter is toggled
  final VoidCallback onFavoriteToggled;

  /// Callback when search term changes
  final void Function(String) onSearchTermChanged;

  /// Callback when country selection changes
  final void Function(String?) onCountryChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Search field
        Expanded(
          flex: 3,
          child: FilterSearchField(
            searchTerm: searchTerm,
            onChanged: onSearchTermChanged,
          ),
        ),
        SizedBox(width: AppSpacing.sm),
        // Country selector
        Expanded(
          flex: 2,
          child: FilterCountrySelector(
            selectedCountry: selectedCountry,
            countries: countries,
            onChanged: onCountryChanged,
          ),
        ),
        SizedBox(width: AppSpacing.sm),
        // Favorite filter
        FilterFavoriteButton(
          showFavorites: showFavorites,
          onToggled: onFavoriteToggled,
        ),
      ],
    );
  }
}
