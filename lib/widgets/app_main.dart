import 'package:easy_localization/easy_localization.dart';
import 'package:farmer_counter/cubits/settings/settings_cubit.dart';
import 'package:farmer_counter/utils/drive_sync_host.dart';
import 'package:farmer_counter/utils/drive_sync_service.dart';
import 'package:farmer_counter/widgets/bottom_navigation_bar/scale_aware_bottom_bar.dart';
import 'package:farmer_counter/widgets/pages/counters_page.dart';
import 'package:farmer_counter/widgets/pages/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class AppMain extends StatefulWidget {
  const AppMain();

  @override
  State<AppMain> createState() => _AppMainState();
}

class _AppMainState extends State<AppMain> {
  @override
  Widget build(BuildContext context) {
    final DriveSyncService syncService = GetIt.instance.get();
    return EasyLocalization(
      supportedLocales: const <Locale>[Locale('en'), Locale('pl')],
      path: 'assets/i18n',
      useOnlyLangCode: true,
      fallbackLocale: const Locale('en'),
      child: Builder(
        builder: (BuildContext context) => MaterialApp(
          locale: context.locale,
          themeMode: ThemeMode.system,
          theme: _getThemeData(Brightness.light),
          darkTheme: _getThemeData(Brightness.dark),
          supportedLocales: context.supportedLocales,
          localizationsDelegates: context.localizationDelegates,
          debugShowCheckedModeBanner: false,
          home: BlocProvider<SettingsCubit>(
            create: (BuildContext context) => SettingsCubit(),
            child: Builder(
              builder: (BuildContext context) => DefaultTabController(
                length: 2,
                child: DriveSyncHost(
                  child: SafeArea(
                    top: false,
                    child: Scaffold(
                      body: TabBarView(
                        children: <Widget>[
                          const CountersPage(),
                          SettingsPage(syncService: syncService),
                        ],
                      ),
                      bottomNavigationBar: ScaleAwareBottomBar(
                        tabs: <Widget>[
                          Tab(icon: const Icon(Icons.add_circle_rounded), text: 'app_main.counters'.tr()),
                          Tab(icon: const Icon(Icons.settings), text: 'app_main.settings'.tr()),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  ThemeData _getThemeData(Brightness brightness) => ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.orange,
          brightness: brightness,
        ),
      );
}
