import 'package:flutter/material.dart';

/// A widget that displays a favicon image or a radio icon if the image is not
/// available.
class RadioFaviconTile extends StatelessWidget {
  /// Creates a new instance of [RadioFaviconTile]
  const RadioFaviconTile({required this.favicon, super.key});

  /// The favicon URL
  final String? favicon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 24,
      height: 24,
      child:
          favicon != null
              ? Image.network(
                favicon!,
                errorBuilder:
                    (context, error, stackTrace) => const Icon(Icons.radio),
              )
              : const Icon(Icons.radio),
    );
  }
}
