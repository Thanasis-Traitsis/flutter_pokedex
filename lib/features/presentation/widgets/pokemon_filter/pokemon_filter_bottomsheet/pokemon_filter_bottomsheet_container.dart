import 'package:bloc_pagination/core/constants/app_decoration.dart';
import 'package:bloc_pagination/core/constants/app_spacing.dart';
import 'package:bloc_pagination/core/constants/app_strings.dart';
import 'package:flutter/material.dart';

class PokemonFilterBottomsheetContainer extends StatelessWidget {
  final List<Widget> pokemonFilterCategories;
  final VoidCallback applyButtonOnPressed;

  const PokemonFilterBottomsheetContainer(
      {super.key,
      required this.pokemonFilterCategories,
      required this.applyButtonOnPressed});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.only(
          left: AppSpacing.screenPadding,
          right: AppSpacing.screenPadding,
          top: AppSpacing.screenPadding,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppStrings.filterHeader,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: AppSpacing.xs),
            Divider(thickness: AppDecoration.filterDividerWidth),
            const SizedBox(height: AppSpacing.xs),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: pokemonFilterCategories,
            ),
            const SizedBox(height: AppSpacing.md),
            Center(
              child: FilledButton(
                onPressed: applyButtonOnPressed,
                child: Text(AppStrings.applyFiltersButtonText),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
