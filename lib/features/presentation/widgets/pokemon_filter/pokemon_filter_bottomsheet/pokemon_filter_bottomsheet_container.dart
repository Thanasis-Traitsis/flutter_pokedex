import 'package:bloc_pagination/config/theme/custom_text_type.dart';
import 'package:bloc_pagination/core/constants/app_decoration.dart';
import 'package:bloc_pagination/core/constants/app_spacing.dart';
import 'package:bloc_pagination/core/constants/app_strings.dart';
import 'package:bloc_pagination/core/widgets/custom_text.dart';
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
            CustomText(
              text: AppStrings.filterHeader,
              textType: CustomTextType.titleMedium,
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
