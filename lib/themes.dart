import 'package:flutter/material.dart';

class CustomThemes {
  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: Colors.white,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        titleTextStyle: TextStyle(
          color: Colors.black,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        elevation: 0,
      ),
      scaffoldBackgroundColor: Colors.white,
      fontFamily: 'Montserrat',
      textTheme: const TextTheme(
        bodyText1: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.normal,
          height: 1.3,
        ),
        bodyText2: TextStyle(
          color: Colors.grey,
          height: 1.4,
        ),
      ),
      buttonTheme: ButtonThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.0),
        ),
        buttonColor: Colors.blue,
      ),
    );
  }
}
