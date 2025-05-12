import 'package:bloc_pagination/config/theme/colors.dart';
import 'package:bloc_pagination/core/constants/app_sizes.dart';
import 'package:flutter/material.dart';

class AppTheme {
  final AppColors chosenColor;

  AppTheme(
    this.chosenColor,
  );

  ThemeData getTheme() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: chosenColor.primaryColor,
        surface: chosenColor.backgroundColor,
        onPrimary: chosenColor.blackColor,
        onSurface: chosenColor.whiteColor,
        surfaceContainer: chosenColor.grayColor,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: ButtonStyle(
          foregroundColor: WidgetStateProperty.all(chosenColor.whiteColor),
        ),
      ),
      extensions: <ThemeExtension<dynamic>>[
        chosenColor,
      ],
    );
  }
}
