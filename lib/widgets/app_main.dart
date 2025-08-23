import 'package:easy_localization/easy_localization.dart';
import 'package:farmer_counter/widgets/counters/counters_page.dart';
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
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange, brightness: Brightness.light),
          ),
          darkTheme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange, brightness: Brightness.dark),
          ),
          supportedLocales: context.supportedLocales,
          localizationsDelegates: context.localizationDelegates,
          debugShowCheckedModeBanner: false,
          home: const CountersPage(),
        ),
      ),
    );
  }
}
