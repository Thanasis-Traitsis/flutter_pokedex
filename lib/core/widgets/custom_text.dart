import 'package:bloc_pagination/config/theme/custom_text_type.dart';
import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  final String text;
  final int? maxLines;
  final CustomTextType textType;
  final TextAlign? textAlign;
  final TextOverflow? overflow;
  final TextStyle? textStyle;
  final bool isWhite;

  const CustomText({
    super.key,
    required this.text,
    this.maxLines,
    required this.textType,
    this.textAlign,
    this.overflow,
    this.textStyle,
    this.isWhite = false,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: textStyle ?? textType.getTextStyle(context, isWhite),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}

