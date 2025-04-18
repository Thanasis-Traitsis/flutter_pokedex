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
        surfaceContainerLow: chosenColor.grayColor,
      ),
      textTheme: TextTheme(
        titleMedium: TextStyle(
          fontSize: AppSizes.titleNormal,
          color: chosenColor.textColor,
          fontWeight: FontWeight.bold,
        ),
        titleSmall: TextStyle(
          fontSize: AppSizes.titleSmall,
          color: chosenColor.textColor,
          fontWeight: FontWeight.bold,
        ),
        bodyMedium: TextStyle(
          fontSize: AppSizes.textNormal,
          color: chosenColor.textColor,
        ),
      ),
      extensions: <ThemeExtension<dynamic>>[
        chosenColor,
      ],
    );
  }
}