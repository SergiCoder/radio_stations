import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:radio_stations/features/radio/presentation/bloc/radio_page_bloc.dart';
import 'package:radio_stations/features/radio/presentation/bloc/radio_page_events.dart';
import 'package:radio_stations/features/radio/presentation/widgets/molecules/radio_page_app_bar.dart';

/// A template widget for displaying the error state
class RadioErrorTemplate extends StatelessWidget {
  /// Creates a new instance of [RadioErrorTemplate]
  const RadioErrorTemplate({required this.errorMessage, super.key});

  /// The error message to display
  final String errorMessage;

  @override
  Widget build(BuildContext context) {
    final sixtyPercentWidth = MediaQuery.of(context).size.width * 0.6;

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
              const SizedBox(height: 16),
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
