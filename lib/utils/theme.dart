import 'package:flutter/material.dart';

class AppTheme {
  static const Map<int, Color> indigo = {
    50: Color(0xFFE8EAF6),
    100: Color(0xFFC5CAE9),
    200: Color(0xFF9FA8DA),
    300: Color(0xFF7986CB),
    400: Color(0xFF5C6BC0),
    500: Colors.indigo,
    600: Color(0xFF3949AB),
    700: Color(0xFF303F9F),
    800: Color(0xFF283593),
    900: Color(0xFF1A237E),
  };

  static const Map<int, Color> primaryColorShade = {
    50: Color.fromRGBO(254, 219, 208, .1),
    100: Color.fromRGBO(254, 219, 208, .2),
    200: Color.fromRGBO(254, 219, 208, .3),
    300: Color.fromRGBO(254, 219, 208, .4),
    400: Color.fromRGBO(254, 219, 208, .5),
    500: Color.fromRGBO(254, 219, 208, .6),
    600: Color.fromRGBO(254, 219, 208, .7),
    700: Color.fromRGBO(254, 219, 208, .8),
    800: Color.fromRGBO(254, 219, 208, .9),
    900: Color.fromRGBO(254, 219, 208, 1),
  };

  static const Map<int, Color> accentColorShade = {
    50: Color.fromRGBO(236, 170, 149, .1),
    100: Color.fromRGBO(236, 170, 149, .2),
    200: Color.fromRGBO(236, 170, 149, .3),
    300: Color.fromRGBO(236, 170, 149, .4),
    400: Color.fromRGBO(236, 170, 149, .5),
    500: Color.fromRGBO(236, 170, 149, .6),
    600: Color.fromRGBO(236, 170, 149, .7),
    700: Color.fromRGBO(236, 170, 149, .8),
    800: Color.fromRGBO(236, 170, 149, .9),
    900: Color.fromRGBO(236, 170, 149, 1),
  };
  static const pink50 = const Color(0xFFFEEAE6);
  static const pink100 = const Color(0xFFFEDBD0);
  static const pink300 = const Color(0xFFFBB8AC);
  static const pink400 = const Color(0xFFEAA4A4);

  static const brown900 = const Color(0xFF442B2D);

  static const accentColor = brown900;
  static const primaryColor = pink100;

  static const errorRed = const Color(0xFFC5032B);

  static const surfaceWhite = const Color(0xFFFFFBFA);
  static const backgroundWhite = Colors.white;
  static const greyColor = Colors.grey;

  static const textWhite = Colors.white;
  static const black = Colors.black;
}
