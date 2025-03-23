import 'package:flutter/material.dart';

/// A simple button widget for toggling favorite filter
class FavoriteFilterButton extends StatelessWidget {
  /// Creates a new instance of [FavoriteFilterButton]
  const FavoriteFilterButton({
    required this.showFavorites,
    required this.onPressed,
    super.key,
  });

  /// The current state of the favorite filter
  final bool showFavorites;

  /// Callback when the button is pressed
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        showFavorites ? Icons.favorite : Icons.favorite_border,
        color: showFavorites ? Theme.of(context).colorScheme.primary : null,
      ),
      onPressed: onPressed,
      tooltip:
          showFavorites ? 'Show Non-Favorites Only' : 'Show Favorites Only',
    );
  }
}
