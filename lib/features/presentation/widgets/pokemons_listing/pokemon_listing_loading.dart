import 'package:bloc_pagination/core/constants/app_spacing.dart';
import 'package:bloc_pagination/features/presentation/widgets/pokemons_listing/pokemon_listing_loading_item.dart';
import 'package:flutter/material.dart';

class PokemonListingLoading extends StatelessWidget {
  const PokemonListingLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 6,
      itemBuilder: (context, index) {
        return Container(
          margin: EdgeInsets.only(top: index != 0 ? AppSpacing.lg : 0),
          child: PokemonListingLoadingItem(),
        );
      },
    );
  }
}
