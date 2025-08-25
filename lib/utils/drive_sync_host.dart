import 'package:easy_localization/easy_localization.dart';
import 'package:farmer_counter/utils/drive_sync_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get_it/get_it.dart';

class DriveSyncHost extends HookWidget {
  final Widget child;

  const DriveSyncHost({
    required this.child,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final DriveSyncService syncService = GetIt.instance.get<DriveSyncService>();
    useEffect(
      () {
        Future<void>.microtask(() async {
          await syncService.client.loadState();
          syncService.hasConflict.addListener(() async {
            if (syncService.hasConflict.value) {
              await _showDriveConflictDialog(context, syncService);
            }
          });
          await syncService.init();
        });

        return syncService.dispose;
      },
      const <Object?>[],
    );

    return child;
  }

  Future<void> _showDriveConflictDialog(
    BuildContext context,
    DriveSyncService svc,
  ) async {
    final String? choice = await showDialog<String>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('drive_sync.conflict.title'.tr()),
        content: Text('drive_sync.conflict.message'.tr()),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'drive'),
            child: Text('drive_sync.conflict.keep_drive'.tr()),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, 'local'),
            child: Text('drive_sync.conflict.keep_local'.tr()),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, 'both'),
            child: Text('drive_sync.conflict.keep_both'.tr()),
          ),
        ],
      ),
    );

    if (choice == 'local') {
      await svc.resolveKeepLocal();
    } else if (choice == 'drive') {
      await svc.resolveKeepDrive();
    } else if (choice == 'both') {
      await svc.resolveKeepBoth();
    } else {
      svc.hasConflict.value = false;
    }
  }
}
