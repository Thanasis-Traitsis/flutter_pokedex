import 'package:bloc_pagination/core/constants/app_decoration.dart';
import 'package:bloc_pagination/core/constants/app_spacing.dart';
import 'package:bloc_pagination/core/utils/extensions/text_capitalize.dart';
import 'package:bloc_pagination/features/presentation/widgets/pokemon_card/pokemon_card_favorite_icon.dart';
import 'package:bloc_pagination/features/presentation/widgets/pokemon_card/pokemon_card_image.dart';
import 'package:bloc_pagination/features/presentation/widgets/pokemon_card/pokemon_card_types.dart';
import 'package:flutter/material.dart';

import 'package:bloc_pagination/features/domain/entities/pokemon_entity.dart';

class PokemonCard extends StatelessWidget {
  final PokemonEntity pokemon;

  const PokemonCard({
    super.key,
    required this.pokemon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.cardPadding),
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).colorScheme.surfaceContainer,
          width: AppDecoration.cardBorderWidth,
        ),
        borderRadius: AppDecoration.cardBorderRadius,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          PokemonCardImage(pokemon.image),
          SizedBox(
            width: AppSpacing.md,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            pokemon.name.formatPokemonName(),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          SizedBox(
                            height: AppSpacing.xs,
                          ),
                          PokemonCardTypes(
                            pokeTypes: pokemon.types,
                          ),
                        ],
                      ),
                    ),
                    PokemonCardFavoriteIcon(
                      isFavorite: pokemon.isFavorite,
                      pokeId: pokemon.id,
                    )
                  ],
                ),
                SizedBox(
                  height: AppSpacing.xs,
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Text(
                    pokemon.id.intoId(),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
