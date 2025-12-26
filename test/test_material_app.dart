import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class TestMaterialApp extends StatelessWidget {
  static final GlobalKey<State<StatefulWidget>> repaintKey = GlobalKey();

  final Widget home;

  const TestMaterialApp({
    required this.home,
  });

  @override
  Widget build(BuildContext context) {
    return EasyLocalization(
      supportedLocales: const <Locale>[
        Locale('en'),
      ],
      path: 'assets/i18n',
      fallbackLocale: const Locale('en'),
      child: Builder(
        builder: (BuildContext context) => RepaintBoundary(
          key: repaintKey,
          child: MaterialApp(
            locale: context.locale,
            supportedLocales: context.supportedLocales,
            localizationsDelegates: context.localizationDelegates,
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
              useMaterial3: true,
            ),
            home: home,
          ),
        ),
      ),
    );
  }
}
