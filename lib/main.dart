import 'package:flutter/material.dart';
import 'package:news_app/provider/theme_changer_notifier.dart';
import 'package:provider/provider.dart';

import 'Splash/splash_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => ThemeChanger())],
      child: Builder(builder: (BuildContext context) {
        final themeChanger = Provider.of<ThemeChanger>(context);

        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'News App',
          themeMode: themeChanger.themeMode,
          home: SplashScreen(),
          theme: ThemeData(brightness: Brightness.light),
          darkTheme: ThemeData(brightness: Brightness.dark),
        );
      }),
    );
  }
}
