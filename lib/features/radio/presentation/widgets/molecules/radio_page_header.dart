import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:radio_stations/core/design_system/theme/theme.dart';
import 'package:radio_stations/features/radio/presentation/presentation.dart';

/// A widget that displays the search and filter controls below the app bar
class RadioPageHeader extends StatelessWidget {
  /// Creates a new instance of [RadioPageHeader]
  const RadioPageHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RadioPageBloc, RadioPageState>(
      builder: (context, state) {
        if (state is! RadioPageLoaded) {
          return const SizedBox.shrink();
        }

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: const BoxDecoration(
            color: AppColors.surface,
            boxShadow: [
              BoxShadow(
                color: Color(0x1A000000),
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: FilterBar(stationCount: state.stations.length),
        );
      },
    );
  }
}
