import 'dart:developer' as dev;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.fromLTRB(15, 0, 5, 0),
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
            SizedBox(
              width: 24,
              height: 24,
              child:
                  station.broken
                      ? Icon(
                        Icons.error_outline,
                        color: Theme.of(context).colorScheme.error,
                      )
                      : null,
            ),
            IconButton(
              icon:
                  (station.isFavorite)
                      ? Icon(
                        Icons.favorite,
                        color: Theme.of(context).colorScheme.primary,
                      )
                      : const Icon(Icons.favorite_border),
              onPressed: () {
                // Unfocus before toggling favorite
                InputUtils.unfocusAndThen(context, () {
                  context.read<RadioPageBloc>().add(
                    StationFavoriteToggled(station),
                  );
                });
              },
            ),
          ],
        ),
        onTap: () {
          dev.log('Selected station: $station');
          // Unfocus before selecting station
          InputUtils.unfocusAndThen(context, onTap);
        },
      ),
    );
  }
}
