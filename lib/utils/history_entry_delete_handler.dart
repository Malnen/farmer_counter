import 'package:easy_localization/easy_localization.dart';
import 'package:farmer_counter/cubits/counter_cubit/counter_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HistoryEntryDeleteHandler {
  static Future<void> show(
    BuildContext context, {
    required String guid,
    required int changeId,
  }) async {
    final bool confirmed = await showDialog<bool>(
          context: context,
          builder: (BuildContext dialogContext) => AlertDialog(
            title: Text('counter_details_page.history.delete_title'.tr()),
            content: Text('counter_details_page.history.delete_message'.tr()),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(false),
                child: Text('common.cancel'.tr()),
              ),
              FilledButton.tonal(
                onPressed: () => Navigator.of(dialogContext).pop(true),
                child: Text('counter_details_page.history.delete_cta'.tr()),
              ),
            ],
          ),
        ) ??
        false;

    if (confirmed) {
      await context.read<CounterCubit>().deleteHistoryEntry(guid, changeId);
    }
  }
}
