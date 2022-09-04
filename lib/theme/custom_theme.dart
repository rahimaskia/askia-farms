import 'color_state.dart';
import 'package:flutter/material.dart';

const textColor = Colors.white;
const btnTextPressedColor = Colors.white70;
const btnColor = Colors.teal;
const btnPressedColor = Colors.tealAccent;
final btnHoverColor = Colors.teal[800];
final btnSplashColor = Colors.teal[900];
const textBtnColor = Colors.blue;
final textBtnPressedColor = Colors.blue[900]!.withAlpha(0);

class CustomTheme {
  static ThemeData get lightTheme => ThemeData(
      brightness: Brightness.light,
      fontFamily: 'Montserrat',
      primaryColor: Colors.white,
      progressIndicatorTheme: const ProgressIndicatorThemeData(color: btnColor),
      indicatorColor: btnColor,
      floatingActionButtonTheme: FloatingActionButtonThemeData(
          foregroundColor: Colors.white,
          backgroundColor: btnColor,
          splashColor: btnSplashColor,
          hoverColor: btnHoverColor),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black54,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
              backgroundColor: ColorState(
                  defaultColor: btnColor, pressedColor: btnPressedColor),
              foregroundColor: ColorState(
                  defaultColor: Colors.white, pressedColor: Colors.white60))),
      appBarTheme:
          AppBarTheme(color: Colors.white, foregroundColor: Colors.grey[900]));

  static ThemeData get darkTheme => ThemeData(
      brightness: Brightness.dark,
      fontFamily: 'Montserrat',
      progressIndicatorTheme: const ProgressIndicatorThemeData(color: btnColor),
      indicatorColor: btnColor,
      floatingActionButtonTheme: FloatingActionButtonThemeData(
          foregroundColor: Colors.white,
          backgroundColor: btnColor,
          splashColor: btnSplashColor,
          hoverColor: btnHoverColor),
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
              backgroundColor: ColorState(
                  defaultColor: btnColor, pressedColor: btnPressedColor),
              foregroundColor: ColorState(
                  defaultColor: Colors.white, pressedColor: Colors.white60))),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white54,
      ));
}
