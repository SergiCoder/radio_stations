import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:radio_stations/features/radio/presentation/bloc/radio_page_bloc.dart';
import 'package:radio_stations/features/radio/presentation/bloc/radio_page_events.dart';
import 'package:radio_stations/features/radio/presentation/bloc/radio_page_states.dart';
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
  /// [bloc] is the bloc that manages the state of this page
  const RadioPage({required RadioPageBloc bloc, super.key}) : _bloc = bloc;

  final RadioPageBloc _bloc;

  @override
  Widget build(BuildContext context) {
    _bloc.add(const RadioPageInitialized());
    return BlocProvider(
      create: (context) => _bloc,
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
    return BlocBuilder<RadioPageBloc, RadioPageState>(
      builder: (context, state) {
        if (state is RadioPageSyncProgress) {
          return const RadioSyncProgressTemplate();
        }

        if (state is RadioPageError) {
          return RadioErrorTemplate(errorMessage: state.errorMessage);
        }

        if (state is RadioPageLoaded) {
          return const RadioLoadedTemplate();
        }

        return const SizedBox.shrink();
      },
    );
  }
}
