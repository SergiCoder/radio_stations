import 'package:flutter/material.dart';
import 'package:radio_stations/features/radio/presentation/widgets/molecules/radio_page_app_bar.dart';
import 'package:radio_stations/features/radio/presentation/widgets/organisms/sync_progress_column.dart';

/// A template widget for displaying the sync progress state
class RadioSyncProgressTemplate extends StatelessWidget {
  /// Creates a new instance of [RadioSyncProgressTemplate]
  const RadioSyncProgressTemplate({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: RadioPageAppBar(),
      body: Center(child: SyncProgressColumn()),
    );
  }
}
