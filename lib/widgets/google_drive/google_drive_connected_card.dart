import 'package:easy_localization/easy_localization.dart';
import 'package:farmer_counter/utils/drive_sync_service.dart';
import 'package:flutter/material.dart';

class GoogleDriveConnectedCard extends StatelessWidget {
  final DriveSyncService syncService;

  const GoogleDriveConnectedCard({required this.syncService});

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
            const Icon(Icons.cloud_done, size: 48, color: Colors.green),
            const SizedBox(height: 12),
            Text(
              'settings.drive.connected_title'.tr(),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.sync),
              label: Text('settings.drive.sync_now'.tr()),
              onPressed: () async {
                await syncService.syncNow();
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('settings.drive.sync_triggered'.tr()),
                  ),
                );
              },
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              icon: const Icon(Icons.cloud_off, color: Colors.red),
              label: Text('settings.drive.disconnect'.tr()),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red,
                side: const BorderSide(color: Colors.red),
              ),
              onPressed: () => _disconnect(context),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _disconnect(BuildContext context) async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('settings.drive.disconnect_confirm.title'.tr()),
        content: Text('settings.drive.disconnect_confirm.message'.tr()),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('settings.drive.disconnect_confirm.cancel'.tr()),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('settings.drive.disconnect_confirm.confirm'.tr()),
          ),
        ],
      ),
    );

    if (confirm ?? false) {
      await syncService.client.disconnect();
      if (!context.mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('settings.drive.disconnected_snackbar'.tr()),
        ),
      );
    }
  }
}
