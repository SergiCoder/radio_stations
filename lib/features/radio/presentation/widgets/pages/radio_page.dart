import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:radio_stations/features/radio/presentation/presentation.dart';

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
      child: BlocBuilder<RadioPageBloc, RadioPageState>(
        builder: (context, state) {
          if (state is RadioPageSyncProgress) {
            return const RadioSyncProgressTemplate();
          } else if (state is RadioPageError) {
            return RadioErrorTemplate(errorMessage: state.errorMessage);
          } else if (state is RadioPageLoaded) {
            return const RadioLoadedTemplate();
          }

          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        },
      ),
    );
  }
}
