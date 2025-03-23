import 'package:bloc_pagination/core/constants/app_spacing.dart';
import 'package:bloc_pagination/features/presentation/widgets/pokemon_image_header.dart';
import 'package:bloc_pagination/features/presentation/widgets/pokemons_listing/pokemon_listing.dart';
import 'package:flutter/material.dart';

class PokemonsScreen extends StatelessWidget {
  const PokemonsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PokemonImageHeader(),
              const SizedBox(
                height: AppSpacing.lg,
              ),
              Expanded(child: PokemonListing()),
            ],
          ),
        ),
      ),
    );
  }
}
