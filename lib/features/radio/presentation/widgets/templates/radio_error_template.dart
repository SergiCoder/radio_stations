import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:radio_stations/core/design_system/theme/app_spacing.dart';
import 'package:radio_stations/features/radio/presentation/presentation.dart';

/// A template widget for displaying the error state
class RadioErrorTemplate extends StatelessWidget {
  /// Creates a new instance of [RadioErrorTemplate]
  const RadioErrorTemplate({required this.errorMessage, super.key});

  /// The error message to display
  final String errorMessage;

  @override
  Widget build(BuildContext context) {
    final sixtyPercentWidth = MediaQuery.sizeOf(context).width * 0.6;

    return Scaffold(
      appBar: const RadioPageAppBar(),
      body: Center(
        child: SizedBox(
          width: sixtyPercentWidth,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Error: $errorMessage',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: AppSpacing.md),
              ElevatedButton(
                onPressed: () {
                  context.read<RadioPageBloc>().add(
                    const RadioStationsRequested(),
                  );
                },
                child: const Text('Back'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
