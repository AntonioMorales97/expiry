import 'package:flutter/material.dart';

class DoloresTheme {
  static ThemeData get lightThemeData {
    /// Create a TextTheme and ColorScheme, that we can use to generate ThemeData
    TextTheme txtTheme = ThemeData.light().textTheme;
    Color txtColor = txtTheme.bodyText1.color;
    ColorScheme colorScheme = ColorScheme(
        // Decide how you want to apply your own custom them, to the MaterialApp
        brightness: Brightness.light,
        primary: Color.fromRGBO(50, 77, 229, 1),
        primaryVariant: Color.fromRGBO(0, 37, 178, 1),
        secondary: Color.fromRGBO(193, 26, 144, 1),
        secondaryVariant: Color.fromRGBO(140, 0, 98, 1),
        background: Color.fromRGBO(255, 255, 250, 1),
        surface: Color.fromRGBO(184, 184, 184, 1),
        onBackground: txtColor,
        onSurface: txtColor,
        onError: Color.fromRGBO(255, 255, 255, 1),
        onPrimary: Color.fromRGBO(255, 255, 255, 1),
        onSecondary: Color.fromRGBO(255, 255, 255, 1),
        error: Colors.red.shade400);

    /// Now that we have ColorScheme and TextTheme, we can create the ThemeData
    var t = ThemeData.from(textTheme: txtTheme, colorScheme: colorScheme)
        // We can also add on some extra properties that ColorScheme seems to miss
        .copyWith(
      buttonColor: colorScheme.primary,
      highlightColor: colorScheme.primary,
      toggleableActiveColor: colorScheme.primary,
      focusColor: colorScheme.primary,
      inputDecorationTheme: InputDecorationTheme(
        focusColor: colorScheme.primary,
        focusedBorder: OutlineInputBorder(
          borderRadius: new BorderRadius.circular(25.0),
          borderSide: BorderSide(color: colorScheme.primary, width: 1.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: new BorderRadius.circular(25.0),
          borderSide: BorderSide(color: colorScheme.onSurface, width: 1.0),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: colorScheme.error, width: 1.0),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: colorScheme.error, width: 2.0),
        ),
      ),
    );

    /// Return the themeData which MaterialApp can now use
    return t;
  }

  // static ThemeData getThemeData(bool isDark) {
  //   /// Create a TextTheme and ColorScheme, that we can use to generate ThemeData
  //   TextTheme txtTheme =
  //       (isDark ? ThemeData.dark() : ThemeData.light()).textTheme;
  //   Color txtColor = txtTheme.bodyText1.color;
  //   ColorScheme colorScheme = ColorScheme(
  //       // Decide how you want to apply your own custom them, to the MaterialApp
  //       brightness: isDark ? Brightness.dark : Brightness.light,
  //       primary: Color.fromRGBO(50, 77, 229, 1),
  //       primaryVariant: Color.fromRGBO(0, 37, 178, 1),
  //       secondary: Color.fromRGBO(193, 26, 144, 1),
  //       secondaryVariant: Color.fromRGBO(140, 0, 98, 1),
  //       background: Color.fromRGBO(255, 255, 250, 1),
  //       surface: Color.fromRGBO(184, 184, 184, 1),
  //       onBackground: txtColor,
  //       onSurface: txtColor,
  //       onError: Color.fromRGBO(255, 255, 255, 1),
  //       onPrimary: Color.fromRGBO(255, 255, 255, 1),
  //       onSecondary: Color.fromRGBO(255, 255, 255, 1),
  //       error: Colors.red.shade400);
  //
  //   /// Now that we have ColorScheme and TextTheme, we can create the ThemeData
  //   var t = ThemeData.from(textTheme: txtTheme, colorScheme: colorScheme)
  //       // We can also add on some extra properties that ColorScheme seems to miss
  //       .copyWith(
  //           buttonColor: Color.fromRGBO(50, 77, 229, 1),
  //           cursorColor: Color.fromRGBO(50, 77, 229, 1),
  //           highlightColor: Color.fromRGBO(50, 77, 229, 1),
  //           toggleableActiveColor: Color.fromRGBO(50, 77, 229, 1));
  //
  //   /// Return the themeData which MaterialApp can now use
  //   return t;
  // }
}
