import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:radio_stations/features/radio/presentation/cubit/radio_page_cubit.dart';

/// A simple button widget for toggling favorite filter
class FavoriteFilterButton extends StatelessWidget {
  /// Creates a new instance of [FavoriteFilterButton]
  const FavoriteFilterButton({super.key});

  @override
  Widget build(BuildContext context) {
    final showFavorites = context.read<RadioPageCubit>().showFavorites;
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
