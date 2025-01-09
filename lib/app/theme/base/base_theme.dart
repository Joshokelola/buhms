import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

abstract class BaseTheme {
  Brightness get brightness;
  ColorScheme get colorScheme;

  ThemeData get theme {
    return ThemeData(
        appBarTheme: const AppBarTheme(
          elevation: 4,
          shadowColor: Colors.black26,
          surfaceTintColor: Colors.transparent, 
          scrolledUnderElevation: 4, 
        ),
        // inputDecorationTheme: const InputDecorationTheme(
        //   fillColor: Color(0xFF333),
        // ),
        textTheme : GoogleFonts.interTextTheme(),
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      //TODO: Customize widgets here
      typography: Typography.material2021(),
    );
  }
}
