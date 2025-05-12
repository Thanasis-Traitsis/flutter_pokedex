import 'package:flutter/material.dart';
import 'package:bloc_pagination/config/theme/colors.dart';
import 'package:bloc_pagination/core/constants/app_sizes.dart';

enum CustomTextType {
  titleMedium,
  titleSmall,
  bodyMediumBold,
  bodyMediumRegular,
}

extension CustomFontSize on CustomTextType {
  double get fontSize => switch (this) {
        CustomTextType.titleMedium => AppSizes.titleMedium,
        CustomTextType.titleSmall => AppSizes.titleSmall,
        CustomTextType.bodyMediumBold ||
        CustomTextType.bodyMediumRegular => AppSizes.textMedium,
      };
}

extension CustomFontWeight on CustomTextType {
  FontWeight get fontWeight => switch (this) {
        CustomTextType.titleMedium ||
        CustomTextType.titleSmall ||
        CustomTextType.bodyMediumBold => FontWeight.bold,
        CustomTextType.bodyMediumRegular => FontWeight.normal,
      };
}

extension CustomTextColor on CustomTextType {
  Color getTextColor(BuildContext context) {
    final appColors = Theme.of(context).extension<AppColors>()!;
    return switch (this) {
      CustomTextType.titleMedium ||
      CustomTextType.titleSmall ||
      CustomTextType.bodyMediumBold => appColors.blackColor,
      CustomTextType.bodyMediumRegular => appColors.textColor,
    };
  }
}

extension CustomTextStyle on CustomTextType {
  TextStyle getTextStyle(BuildContext context, bool isWhite) {
    final appColors = Theme.of(context).extension<AppColors>()!;
    return TextStyle(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: isWhite ? appColors.whiteColor : getTextColor(context),
    );
  }
}
