import 'package:easy_localization/easy_localization.dart';
import 'package:farmer_counter/cubits/settings/settings_cubit.dart';
import 'package:farmer_counter/cubits/settings/settings_state.dart';
import 'package:farmer_counter/enums/summary_metric.dart';
import 'package:farmer_counter/widgets/pages/summary_metrics_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SummaryMetricsCard extends StatelessWidget {
  const SummaryMetricsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final SettingsCubit settingsCubit = context.watch<SettingsCubit>();
    final SettingsState state = settingsCubit.state;
    final int enabledCount = state.summaryMetricsState.entries.where((MapEntry<SummaryMetric, bool> entry) => entry.value).length;

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        title: Text('settings.summary_metrics.title'.tr()),
        subtitle: Text(
          'settings.summary_metrics.subtitle'.tr(
            namedArgs: <String, String>{'count': '$enabledCount'},
          ),
        ),
        trailing: const Icon(Icons.chevron_right),
        splashColor: Colors.transparent,
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => BlocProvider<SettingsCubit>.value(
              value: settingsCubit,
              child: const SummaryMetricsPage(),
            ),
          ),
        ),
      ),
    );
  }
}
