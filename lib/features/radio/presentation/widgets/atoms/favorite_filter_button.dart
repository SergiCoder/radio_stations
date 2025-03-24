import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:radio_stations/features/radio/presentation/cubit/radio_page_cubit.dart';
import 'package:radio_stations/features/radio/presentation/state/radio_page_state.dart';

/// A simple button widget for toggling favorite filter
class FavoriteFilterButton extends StatelessWidget {
  /// Creates a new instance of [FavoriteFilterButton]
  const FavoriteFilterButton({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.select<RadioPageCubit, RadioPageState>(
      (cubit) => cubit.state,
    );

    if (state is! RadioPageLoadedState) {
      return const SizedBox.shrink();
    }

    final showFavorites = state.selectedFilter.favorite;

    return IconButton(
      icon: Icon(
        showFavorites ? Icons.favorite : Icons.favorite_border,
        color: showFavorites ? Theme.of(context).colorScheme.primary : null,
      ),
      onPressed: () {
        context.read<RadioPageCubit>().toggleFavorites();
      },
      tooltip:
          showFavorites ? 'Show Non-Favorites Only' : 'Show Favorites Only',
    );
  }
}
