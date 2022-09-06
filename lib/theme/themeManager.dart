import 'package:flutter/material.dart';

// define colour swatch
Map<int, Color> swatch =
{
  50:Color.fromRGBO(254,165,75, .1),
  100:Color.fromRGBO(254,165,75, .2),
  200:Color.fromRGBO(254,165,75, .3),
  300:Color.fromRGBO(254,165,75, .4),
  400:Color.fromRGBO(254,165,75, .5),
  500:Color.fromRGBO(254,165,75, .6),
  600:Color.fromRGBO(254,165,75, .7),
  700:Color.fromRGBO(254,165,75, .8),
  800:Color.fromRGBO(254,165,75, .9),
  900:Color.fromRGBO(254,165,75, 1),
};

class ThemeNotifier with ChangeNotifier {
  // we only have one theme
  final lightTheme = ThemeData(
    primarySwatch: MaterialColor(0xFFFEA54B, swatch),
    primaryColor: Color(0xFFFEA54B),
    brightness: Brightness.light,
    backgroundColor: Color(0xFFE5E5E5),
    accentColor: Color(0xFF000000),
    accentIconTheme: IconThemeData(color: Colors.white),
    dividerColor: Colors.white54,
    textTheme: TextTheme(
      headline1: TextStyle(
          fontSize: 96.0, fontFamily: 'Roboto', color: Colors.black87),
      headline2: TextStyle(
          fontSize: 60.0, fontFamily: 'Roboto', color: Colors.black87),
      headline3: TextStyle(
          fontSize: 48.0, fontFamily: 'Roboto', color: Colors.black87),
      headline4: TextStyle(
          fontSize: 34.0, fontFamily: 'Roboto', color: Colors.black87),
      headline5: TextStyle(
          fontSize: 24.0, fontFamily: 'Roboto', color: Colors.black87),
      headline6: TextStyle(
          fontSize: 20.0, fontFamily: 'Roboto', color: Colors.black87),
      subtitle1: TextStyle(
          fontSize: 16.0, fontFamily: 'Roboto', color: Colors.black87),
      subtitle2: TextStyle(
          fontSize: 14.0, fontFamily: 'Roboto', color: Colors.black87),
      bodyText1: TextStyle(
          fontSize: 16.0, fontFamily: 'Roboto', color: Colors.black87),
      bodyText2: TextStyle(
          fontSize: 14.0, fontFamily: 'Roboto', color: Colors.black87),
      button: TextStyle(
          fontSize: 14.0, fontFamily: 'Roboto', color: Colors.black87),
      caption: TextStyle(
          fontSize: 12.0, fontFamily: 'Roboto', color: Colors.black87),
      overline: TextStyle(
          fontSize: 10.0, fontFamily: 'Roboto', color: Colors.black87),
    ),
  );

  ThemeData _themeData;
  ThemeData getTheme() => _themeData;

  ThemeNotifier() {
    _themeData = lightTheme;
    notifyListeners();
  }
}
