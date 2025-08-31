import 'package:easy_localization/easy_localization.dart';
import 'package:farmer_counter/extensions/summary_metric_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:farmer_counter/cubits/settings/settings_cubit.dart';
import 'package:farmer_counter/cubits/settings/settings_state.dart';
import 'package:farmer_counter/enums/summary_metric.dart';

class SummaryMetricsPage extends StatelessWidget {
  const SummaryMetricsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('settings.summary_metrics.title'.tr()),
      ),
      body: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (BuildContext context, SettingsState state) {
          final SettingsCubit cubit = context.read<SettingsCubit>();
          return ListView.separated(
            itemCount: SummaryMetric.values.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (BuildContext context, int i) {
              final SummaryMetric metric = SummaryMetric.values[i];
              final bool enabled = cubit.isSummaryMetricEnabled(metric);

              return SwitchListTile(
                value: enabled,
                onChanged: (bool value) => cubit.setSummaryMetric(metric, value),
                title: Text(metric.label),
                subtitle: Text(metric.description),
                secondary: Icon(metric.icon),
              );
            },
          );
        },
      ),
    );
  }
}
