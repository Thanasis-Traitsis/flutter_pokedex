// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class AppColors extends ThemeExtension<AppColors> {
  final Color whiteColor;
  final Color blackColor;
  final Color backgroundColor;
  final Color textColor;
  final Color primaryColor;
  final Color grayColor;
  final Color favoriteActive;
  final Color favoriteInactive;

  AppColors({
    required this.whiteColor,
    required this.blackColor,
    required this.backgroundColor,
    required this.textColor,
    required this.primaryColor,
    required this.grayColor,
    required this.favoriteActive,
    required this.favoriteInactive,
  });

  static final mainColors = AppColors(
    whiteColor: const Color(0xffFFFFFF),
    blackColor: const Color(0xff000000),
    backgroundColor: const Color(0xffFFFFFF),
    textColor: const Color.fromARGB(255, 46, 45, 45),
    primaryColor: const Color.fromARGB(255, 22, 52, 174),
    grayColor: const Color.fromARGB(255, 184, 182, 182),
    favoriteActive: const Color(0xffE53935),
    favoriteInactive: const Color(0xffBDBDBD),
  );

  @override
  AppColors copyWith({
    Color? whiteColor,
    Color? blackColor,
    Color? backgroundColor,
    Color? textColor,
    Color? primaryColor,
    Color? grayColor,
    Color? favoriteActive,
    Color? favoriteInactive,
  }) {
    return AppColors(
      whiteColor: whiteColor ?? this.whiteColor,
      blackColor: blackColor ?? this.blackColor,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      textColor: textColor ?? this.textColor,
      primaryColor: primaryColor ?? this.primaryColor,
      grayColor: grayColor ?? this.grayColor,
      favoriteActive: favoriteActive ?? this.favoriteActive,
      favoriteInactive: favoriteInactive ?? this.favoriteInactive,
    );
  }

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) return this;

    return AppColors(
      whiteColor: Color.lerp(whiteColor, other.whiteColor, t)!,
      blackColor: Color.lerp(blackColor, other.blackColor, t)!,
      backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t)!,
      textColor: Color.lerp(textColor, other.textColor, t)!,
      primaryColor: Color.lerp(primaryColor, other.primaryColor, t)!,
      grayColor: Color.lerp(grayColor, other.grayColor, t)!,
      favoriteActive: Color.lerp(favoriteActive, other.favoriteActive, t)!,
      favoriteInactive:
          Color.lerp(favoriteInactive, other.favoriteInactive, t)!,
    );
  }
}
