import 'package:flutter/material.dart';
import 'package:radio_stations/core/design_system/theme/app_spacing.dart';
import 'package:radio_stations/features/radio/presentation/widgets/organisms/organisms.dart';
import 'package:radio_stations/features/shared/domain/entitites/radio_station.dart';

/// A widget that displays the player information and controls
class PlayerBar extends StatelessWidget {
  /// Creates a new instance of [PlayerBar]
  const PlayerBar({required this.station, super.key});

  /// The currently selected radio station
  final RadioStation station;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        RadioStationInfo(station: station),
        const SizedBox(height: AppSpacing.xs),
        const AudioPlayerControls(),
        const SizedBox(height: AppSpacing.xs),
      ],
    );
  }
}
