import 'package:flutter/material.dart';

final ThemeData mainDarkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: const Color(0xFFFF6812),
  scaffoldBackgroundColor: const Color(0xFF151515),
  cardColor: const Color(0xFF1C1C1C),
  indicatorColor: const Color(0xFFFFFFFF),
  dividerColor: const Color(0xFF484848),
  fontFamily: 'Poppins',
  textTheme: const TextTheme(
    displayLarge: TextStyle(
      fontSize: 24,
      color: Color(0xFFFFFFFF),
      fontWeight: FontWeight.bold,
    ),
    headlineMedium: TextStyle(
      fontSize: 18,
      color: Color(0xFFFFFFFF),
      fontWeight: FontWeight.bold,
    ),
    titleMedium: TextStyle(
      fontSize: 16,
      color: Color(0xFFFFFFFF),
      fontWeight: FontWeight.w600,
    ),
    // subtitle1: const TextStyle(
    //   color: Color(0xFFBEBEBE),
    //   fontWeight: FontWeight.normal,
    // ),
    // subtitle2: const TextStyle(
    //   color: Color(0xFF8A8A8A),
    //   fontWeight: FontWeight.w600,
    // ),
    labelMedium: TextStyle(
      color: Color(0xFFFFFFFF),
      fontWeight: FontWeight.bold,
    ),
  ),
);

final ThemeData mainLightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: Color(0xFFFFFFFF),
  scaffoldBackgroundColor: Color(0xFF151515),
  fontFamily: 'Poppins',
  textTheme: TextTheme(
    bodyText1: TextStyle(color: Color(0xFF151515)),
    bodyText2: TextStyle(color: Color(0xFF151515)),
    // Add other TextStyle properties as needed
  ),
);
