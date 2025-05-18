import 'package:bloc_pagination/config/theme/custom_text_type.dart';
import 'package:bloc_pagination/core/constants/app_decoration.dart';
import 'package:bloc_pagination/core/constants/app_spacing.dart';
import 'package:bloc_pagination/core/models/pokemon_type_model.dart';
import 'package:bloc_pagination/core/widgets/custom_text.dart';
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
              child: CustomText(
                text: type.name.toUpperCase(),
                textType: CustomTextType.bodyMediumRegular,
                isWhite: isSelected,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
