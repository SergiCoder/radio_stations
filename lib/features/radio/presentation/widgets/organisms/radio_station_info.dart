import 'package:flutter/material.dart';
import 'package:radio_stations/core/design_system/theme/app_sizes.dart';
import 'package:radio_stations/core/design_system/theme/app_spacing.dart';
import 'package:radio_stations/core/utils/ui_utils.dart';
import 'package:radio_stations/features/shared/domain/entitites/radio_station.dart';
import 'package:url_launcher/url_launcher.dart';

/// A widget that displays information about a radio station
class RadioStationInfo extends StatelessWidget {
  /// Creates a new instance of [RadioStationInfo]
  const RadioStationInfo({required this.station, super.key});

  /// The radio station to display information about
  final RadioStation station;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final stationIconWidth = UIUtils.getNarrowWidth(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: stationIconWidth,
              height: stationIconWidth,
              child:
                  station.broken
                      ? Icon(
                        Icons.error_outline,
                        color: theme.colorScheme.error,
                        size: AppSizes.iconMedium,
                      )
                      : station.favicon.isNotEmpty
                      ? Image.network(
                        station.favicon,
                        errorBuilder:
                            (context, error, stackTrace) => Icon(
                              Icons.radio,
                              color: theme.colorScheme.primary,
                              size: AppSizes.iconMedium,
                            ),
                      )
                      : Icon(
                        Icons.radio,
                        color: theme.colorScheme.primary,
                        size: AppSizes.avatarExtraLarge,
                      ),
            ),

            const Spacer(),
            Expanded(
              flex: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          station.name,
                          style: theme.textTheme.titleMedium,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  if (station.homepage.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.xs),
                    GestureDetector(
                      onTap: () => launchUrl(Uri.parse(station.homepage)),
                      child: Row(
                        children: [
                          Icon(
                            Icons.language,
                            size: AppSizes.iconSmall,
                            color: theme.colorScheme.onSurface,
                          ),
                          const SizedBox(width: AppSpacing.xs),
                          Expanded(
                            child: Text(
                              station.homepage,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurface,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  if (station.country.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.xs),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          size: AppSizes.iconSmall,
                          color: theme.colorScheme.onSurface,
                        ),
                        const SizedBox(width: AppSpacing.xs),
                        Text(
                          station.country,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
