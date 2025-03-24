import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:radio_stations/core/design_system/theme/app_spacing.dart';
import 'package:radio_stations/features/radio/presentation/presentation.dart';

/// A widget that displays the search and filter controls below the app bar
class RadioPageHeader extends StatelessWidget {
  /// Creates a new instance of [RadioPageHeader]
  const RadioPageHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Select all state needed for the filter controls
    final isLoaded = context.select<RadioPageBloc, bool>(
      (bloc) => bloc.state is RadioPageLoaded,
    );

    if (!isLoaded) {
      return const SizedBox.shrink();
    }

    // Station count
    final stationCount = context.select<RadioPageBloc, int>(
      (bloc) => (bloc.state as RadioPageLoaded).stations.length,
    );

    // Favorites filter
    final showFavorites = context.select<RadioPageBloc, bool>(
      (bloc) => (bloc.state as RadioPageLoaded).selectedFilter.favorite,
    );

    // Country selection
    final selectedCountry = context.select<RadioPageBloc, String?>(
      (bloc) => (bloc.state as RadioPageLoaded).selectedFilter.country,
    );

    final countries = context.select<RadioPageBloc, List<String>>(
      (bloc) => (bloc.state as RadioPageLoaded).countries,
    );

    // Search term
    final searchTerm = context.select<RadioPageBloc, String>(
      (bloc) => (bloc.state as RadioPageLoaded).selectedFilter.searchTerm,
    );

    return Container(
      padding: const EdgeInsets.only(
        bottom: AppSpacing.md,
        left: AppSpacing.xs + 2, // 6px
        right: AppSpacing.xs + 2, // 6px
        top: AppSpacing.xs + 2, // 6px
      ),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: FilterBar(
        stationCount: stationCount,
        showFavorites: showFavorites,
        selectedCountry: selectedCountry,
        countries: countries,
        searchTerm: searchTerm,
        onFavoriteToggled:
            () => context.read<RadioPageBloc>().add(
              const FavoritesFilterToggled(),
            ),
        onCountryChanged:
            (country) =>
                context.read<RadioPageBloc>().add(CountrySelected(country)),
        onSearchTermChanged:
            (term) =>
                context.read<RadioPageBloc>().add(SearchTermChanged(term)),
      ),
    );
  }
}
