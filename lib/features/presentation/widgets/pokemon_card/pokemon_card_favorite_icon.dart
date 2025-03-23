// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bloc_pagination/features/presentation/pokemon_list_bloc/pokemon_list_bloc.dart';
import 'package:flutter/material.dart';

import 'package:bloc_pagination/config/theme/colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PokemonCardFavoriteIcon extends StatelessWidget {
  final bool isFavorite;
  final String pokeId;

  const PokemonCardFavoriteIcon({
    super.key,
    required this.isFavorite,
    required this.pokeId,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).extension<AppColors>()!;

    return GestureDetector(
      onTap: () {
        context.read<PokemonListBloc>().add(ToggleFavoriteStatus(pokeId));
      },
      child: Icon(
        isFavorite ? Icons.favorite : Icons.favorite_border,
        color:
            isFavorite ? appColors.favoriteActive : appColors.favoriteInactive,
      ),
    );
  }
}
