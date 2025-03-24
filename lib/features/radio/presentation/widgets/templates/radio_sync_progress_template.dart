import 'package:flutter/material.dart';
import 'package:radio_stations/features/radio/domain/entities/sync_progress.dart';
import 'package:radio_stations/features/radio/presentation/models/sync_progress_model.dart';
import 'package:radio_stations/features/radio/presentation/widgets/atoms/radio_page_app_bar.dart';
import 'package:radio_stations/features/radio/presentation/widgets/molecules/sync_progress_indicator.dart';

/// A template widget for displaying the sync progress state
class RadioSyncProgressTemplate extends StatelessWidget {
  /// Creates a new instance of [RadioSyncProgressTemplate]
  const RadioSyncProgressTemplate({required this.syncProgress, super.key});

  /// The sync progress
  final SyncProgress syncProgress;

  @override
  Widget build(BuildContext context) {
    final syncProgressModel = SyncProgressModel.fromEntity(syncProgress);
    return Scaffold(
      appBar: const RadioPageAppBar(),
      body: Center(child: SyncProgressIndicator(progress: syncProgressModel)),
    );
  }
}
