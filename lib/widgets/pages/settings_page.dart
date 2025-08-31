import 'package:farmer_counter/utils/drive_client.dart';
import 'package:farmer_counter/utils/drive_sync_service.dart';
import 'package:farmer_counter/widgets/google_drive/google_drive_connected_card.dart';
import 'package:farmer_counter/widgets/google_drive/google_drive_disconnected_card.dart';
import 'package:farmer_counter/widgets/settings/plus_minus_order_card.dart';
import 'package:farmer_counter/widgets/settings/summary_metric_card.dart';
import 'package:farmer_counter/widgets/settings/tab_bar_size_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class SettingsPage extends HookWidget {
  final DriveSyncService syncService;

  const SettingsPage({required this.syncService});

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<bool> loading = useState(false);
    if (loading.value) {
      return const Center(child: CircularProgressIndicator());
    }

    final ValueNotifier<DriveAuthState> authState = useListenable(syncService.client.authState);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        spacing: 16,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const SummaryMetricsCard(),
          const PlusMinusOrderCard(),
          const TabBarSizeCard(),
          if (authState.value == DriveAuthState.connected)
            GoogleDriveConnectedCard(syncService: syncService)
          else
            GoogleDriveDisConnectedCard(
              syncService: syncService,
              loading: loading,
            ),
        ],
      ),
    );
  }
}
