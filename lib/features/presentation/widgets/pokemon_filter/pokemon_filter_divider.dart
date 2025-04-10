import 'package:bloc_pagination/core/constants/app_decoration.dart';
import 'package:bloc_pagination/core/constants/app_spacing.dart';
import 'package:bloc_pagination/core/constants/app_values.dart';
import 'package:flutter/material.dart';

class PokemonFilterDivider extends StatelessWidget {
  const PokemonFilterDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: AppSpacing.md),
      color: Theme.of(context).colorScheme.surfaceContainer,
      width: AppDecoration.filterDividerWidth,
      height: AppValues.filterButtonSize,
    );
  }
}
