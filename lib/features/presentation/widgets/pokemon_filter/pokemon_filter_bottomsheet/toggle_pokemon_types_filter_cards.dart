import 'package:bloc_pagination/config/theme/pokemon_type_model.dart';
import 'package:bloc_pagination/core/constants/app_decoration.dart';
import 'package:bloc_pagination/core/constants/app_spacing.dart';
import 'package:flutter/material.dart';

class TogglePokemonTypesFilterCards extends StatelessWidget {
  final Set<String> selectedTypes;
  final ValueChanged<Set<String>> onChanged;

  const TogglePokemonTypesFilterCards({
    super.key,
    required this.selectedTypes,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.xs,
      runSpacing: AppSpacing.xs,
      children: PokemonType.values.map((type) {
        final isSelected = selectedTypes.contains(type.name);

        return Material(
          color: Colors.transparent,
          borderRadius: AppDecoration.pokeTypesBorderRadius,
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () {
              if (isSelected) {
                selectedTypes.remove(type.name);
              } else {
                selectedTypes.add(type.name);
              }
              onChanged(selectedTypes); 
            },
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.typesCardPadding,
                vertical: AppSpacing.typesCardPadding / 3,
              ),
              decoration: BoxDecoration(
                color: isSelected
                    ? Theme.of(context).colorScheme.primary
                    : Colors.transparent,
                borderRadius: AppDecoration.pokeTypesBorderRadius,
                border: Border.all(
                  width: AppDecoration.filterBorderWidth,
                  color: Theme.of(context).colorScheme.surfaceContainer,
                ),
              ),
              child: Text(
                type.name.toUpperCase(),
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: isSelected
                          ? Theme.of(context).colorScheme.surface
                          : Theme.of(context).textTheme.bodyMedium!.color,
                    ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
