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
    return BlocSelector<SettingsCubit, SettingsState, int>(
      selector: (SettingsState state) =>
          state.summaryMetricsState.entries.where((MapEntry<SummaryMetric, bool> entry) => entry.value).length,
      builder: (BuildContext context, int enabledCount) => Card(
        child: ListTile(
          title: Text('settings.summary_metrics.title'.tr()),
          subtitle: Text(
            'settings.summary_metrics.subtitle'.tr(namedArgs: <String, String>{'count': '$enabledCount'}),
          ),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) => BlocProvider<SettingsCubit>.value(
                value: context.read(),
                child: const SummaryMetricsPage(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
