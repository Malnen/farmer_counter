import 'package:easy_localization/easy_localization.dart';
import 'package:farmer_counter/utils/drive_sync_service.dart';
import 'package:flutter/material.dart';

class GoogleDriveDisConnectedCard extends StatelessWidget {
  final DriveSyncService syncService;
  final ValueNotifier<bool> loading;

  const GoogleDriveDisConnectedCard({required this.syncService, required this.loading});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: <Widget>[
            const Icon(Icons.cloud, size: 48, color: Colors.blue),
            const SizedBox(height: 12),
            Text(
              'settings.drive.not_connected_title'.tr(),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.login),
              label: Text('settings.drive.connect'.tr()),
              onPressed: () => _connect(loading, context),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _connect(ValueNotifier<bool> loading, BuildContext context) async {
    if (loading.value) {
      return;
    }

    loading.value = true;
    final bool ok = await syncService.client.connect();
    loading.value = false;

    if (!context.mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          ok ? 'settings.drive.connected_snackbar'.tr() : 'settings.drive.failed_snackbar'.tr(),
        ),
      ),
    );

    if (ok) {
      await syncService.syncNow();
    }
  }
}
