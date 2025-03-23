import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:radio_stations/features/radio/presentation/cubit/radio_page_cubit.dart';
import 'package:radio_stations/features/radio/presentation/state/radio_page_state.dart';
import 'package:radio_stations/features/radio/presentation/widgets/templates/radio_error_template.dart';
import 'package:radio_stations/features/radio/presentation/widgets/templates/radio_loaded_template.dart';
import 'package:radio_stations/features/radio/presentation/widgets/templates/radio_sync_progress_template.dart';

/// The main page for the radio application
///
/// This is the main page of the radio stations application. It shows
/// a list of available radio stations and allows the user to browse and
/// interact with them.
class RadioPage extends StatelessWidget {
  /// Creates a new instance of [RadioPage]
  ///
  /// [cubit] is the cubit that manages the state of this page
  const RadioPage({required RadioPageCubit cubit, super.key}) : _cubit = cubit;

  final RadioPageCubit _cubit;

  @override
  Widget build(BuildContext context) {
    _cubit.init();
    return BlocProvider(
      create: (context) => _cubit,
      child: const _RadioPageView(),
    );
  }
}

/// The view component of the RadioPage
///
/// This widget is responsible for displaying the UI based on the current state.
class _RadioPageView extends StatelessWidget {
  /// Creates a new instance of [_RadioPageView]
  const _RadioPageView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RadioPageCubit, RadioPageState>(
      builder: (context, state) {
        if (state is RadioPageSyncProgressState) {
          return RadioSyncProgressTemplate(syncProgress: state.syncProgress);
        }

        if (state is RadioPageErrorState) {
          return RadioErrorTemplate(errorMessage: state.errorMessage);
        }

        if (state is RadioPageLoadedState) {
          return RadioLoadedTemplate(stations: state.stations);
        }

        return const SizedBox.shrink();
      },
    );
  }
}
