import 'package:bloc_pagination/config/theme/custom_text_type.dart';
import 'package:bloc_pagination/core/widgets/custom_text.dart';
import 'package:flutter/material.dart';

import 'package:bloc_pagination/config/theme/pokemon_type_model.dart';
import 'package:bloc_pagination/core/constants/app_decoration.dart';
import 'package:bloc_pagination/core/constants/app_spacing.dart';

class PokemonCardTypes extends StatelessWidget {
  final List<PokemonType> pokeTypes;

  const PokemonCardTypes({
    super.key,
    required this.pokeTypes,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      direction: Axis.horizontal,
      spacing: AppSpacing.xs,
      runSpacing: AppSpacing.xs,
      children: List.generate(
        (pokeTypes.length),
        (index) {
          return Container(
            padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.typesCardPadding,
                vertical: AppSpacing.typesCardPadding / 3),
            decoration: BoxDecoration(
              color: pokeTypes[index].color,
              borderRadius: AppDecoration.pokeTypesBorderRadius,
            ),
            child: CustomText(
              text: pokeTypes[index].name.toUpperCase(),
              textType: CustomTextType.bodyMediumRegular,
              isWhite: true,
            ),
          );
        },
      ),
    );
  }
}
