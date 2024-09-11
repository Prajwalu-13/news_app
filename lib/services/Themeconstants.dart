import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/theme_changer_notifier.dart';

class Themeconstants {
  static Color primarybgColor = Color(0xffe7ecf1);
  static Color primaryTextColor = Color(0xff0b2a53);
  static Color primaryColor = Color(0xff3b71af);

  static Color getPrimaryTextColor(BuildContext context) {
    final themeChanger = Provider.of<ThemeChanger>(context);
    return themeChanger.themeMode == ThemeMode.light
        ? Color(0xff0b2a53) // Light theme color
        : Color(0xffffffff); // Dark theme color
  }

  static Color getCardColor(BuildContext context) {
    final themeChanger = Provider.of<ThemeChanger>(context);
    return themeChanger.themeMode == ThemeMode.light
        ? Color(0xffe7ecf1) // Light theme color
        : Color(0xff36454f); // Dark theme color
  }

  static Color getbottomNavColor(BuildContext context) {
    final themeChanger = Provider.of<ThemeChanger>(context);
    return themeChanger.themeMode == ThemeMode.light
        ? Color(0xffe7ecf1) // Light theme color
        : Color(0xFF607D8B); // Dark theme color
  }
}
