import 'package:buhms/app/theme/base/base_theme.dart';
import 'package:flutter/material.dart';

final class LightTheme extends BaseTheme {
  @override
  Brightness get brightness => Brightness.light;

  @override
  ColorScheme get colorScheme => _colorScheme;

  ColorScheme get _colorScheme {
    return const ColorScheme(
      primary: Color(0xFF2C3E50), // Dark Blue
      primaryContainer:
          Color(0xFF34495E), // Slightly lighter version of primary
      secondary: Color(0xFF3498DB), // Light Blue
      secondaryContainer: Color(0xFF2980B9), // Darker version of secondary
      surface: Color(0xFFf5f7fa), // Light Grey
      error: Colors.red,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: Color(0xFF2C3E50), // Dark Blue for text
      onError: Colors.white,
      brightness: Brightness.light,
    );
  }
}
