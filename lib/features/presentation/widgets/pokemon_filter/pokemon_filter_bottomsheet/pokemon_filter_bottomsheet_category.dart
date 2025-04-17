import 'package:bloc_pagination/core/constants/app_spacing.dart';
import 'package:flutter/material.dart';

class PokemonFilterBottomsheetCategory extends StatelessWidget {
  final String title;
  final Widget filterCategory;
  final bool spacingBetween;

  const PokemonFilterBottomsheetCategory(
      {super.key,
      required this.title,
      required this.filterCategory,
      this.spacingBetween = true});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "$title:",
          style: Theme.of(context).textTheme.titleSmall,
        ),
        spacingBetween
            ? const SizedBox(height: AppSpacing.md)
            : const SizedBox.shrink(),
        filterCategory,
      ],
    );
  }
}
