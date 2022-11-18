import 'package:flutter/material.dart';
import 'package:table_now/ui/custom_color.dart';

ThemeData theme() {
  return ThemeData(
    primaryColor: primaryColor,
    scaffoldBackgroundColor: Colors.white,
    // fontFamily: 'OpenSans',
    appBarTheme: const AppBarTheme(
      color: Colors.white,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontSize: 18,
        color: Colors.black,
      ),
      elevation: 0,
    ),
    // splashColor: primaryColor.withOpacity(0.1),
    // highlightColor: primaryColor.withOpacity(0.1),
  );
}
