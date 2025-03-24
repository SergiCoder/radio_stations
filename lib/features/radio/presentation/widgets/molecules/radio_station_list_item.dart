import 'dart:developer' as dev;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:radio_stations/core/design_system/theme/app_sizes.dart';
import 'package:radio_stations/core/design_system/theme/app_spacing.dart';
import 'package:radio_stations/core/utils/input_utils.dart';
import 'package:radio_stations/features/radio/presentation/presentation.dart';
import 'package:radio_stations/features/shared/domain/entitites/radio_station.dart';

/// A widget that displays a radio station in a list
class RadioStationListItem extends StatelessWidget {
  /// Creates a new instance of [RadioStationListItem]
  const RadioStationListItem({
    required this.station,
    required this.onTap,
    super.key,
  });

  /// The radio station to display
  final RadioStation station;

  /// Callback when the item is tapped
  final VoidCallback onTap;

  /// Builds the status indicator for broken stations
  Widget _buildStatusIndicator(BuildContext context) {
    if (!station.broken) {
      return const SizedBox(
        width: AppSizes.iconMedium,
        height: AppSizes.iconMedium,
      );
    }

    return Icon(
      Icons.error_outline,
      color: Theme.of(context).colorScheme.error,
      size: AppSizes.iconMedium,
    );
  }

  /// Builds the favorite button
  Widget _buildFavoriteButton(BuildContext context) {
    final iconData =
        station.isFavorite ? Icons.favorite : Icons.favorite_border;
    final color =
        station.isFavorite ? Theme.of(context).colorScheme.primary : null;

    return IconButton(
      icon: Icon(iconData, color: color),
      onPressed: () {
        InputUtils.unfocusAndThen(context, () {
          context.read<RadioPageBloc>().add(StationFavoriteToggled(station));
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.fromLTRB(
          AppSpacing.md - 1, // 15
          0,
          AppSpacing.xs + 1, // 5
          0,
        ),
        leading: RadioFaviconTile(favicon: station.favicon),
        title: Text(
          station.name,
          style: Theme.of(context).textTheme.titleMedium,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildStatusIndicator(context),
            _buildFavoriteButton(context),
          ],
        ),
        onTap: () {
          dev.log('Selected station: $station');
          InputUtils.unfocusAndThen(context, onTap);
        },
      ),
    );
  }
}
