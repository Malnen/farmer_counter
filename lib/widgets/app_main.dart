import 'package:easy_localization/easy_localization.dart';
import 'package:farmer_counter/widgets/pages/counters_page.dart';
import 'package:flutter/material.dart';

class AppMain extends StatelessWidget {
  const AppMain({super.key});

  @override
  Widget build(BuildContext context) {
    return EasyLocalization(
      supportedLocales: const <Locale>[
        Locale('en'),
        Locale('pl'),
      ],
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
          home: const CountersPage(),
        ),
      ),
    );
  }

  ThemeData _getThemeData(Brightness brightness) => ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange, brightness: brightness),
        tabBarTheme: TabBarThemeData(
          indicator: UnderlineTabIndicator(
            borderSide: BorderSide(
              width: 3,
              color: Colors.white,
            ),
          ),
          labelColor: Colors.white,
          unselectedLabelColor: Colors.grey,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal),
        ),
      );
}
