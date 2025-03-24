import 'package:flutter/material.dart';
import 'package:radio_stations/core/design_system/theme/app_sizes.dart';

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
      width: AppSizes.iconMedium,
      height: AppSizes.iconMedium,
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
