import 'package:bloc_pagination/core/constants/app_spacing.dart';
import 'package:bloc_pagination/core/constants/app_strings.dart';
import 'package:bloc_pagination/features/presentation/widgets/pokemon_filter/toggle_pokemon_favorite_checkbox.dart';
import 'package:flutter/material.dart';

class PokemonFilterBottomsheet extends StatelessWidget {
  const PokemonFilterBottomsheet({super.key});

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
            const Divider(
              thickness: 1,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              "${AppStrings.filterFavoriteTitle}:",
              style: Theme.of(context).textTheme.titleSmall,
            ),
            TogglePokemonFavoriteCheckbox(),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Apply'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
