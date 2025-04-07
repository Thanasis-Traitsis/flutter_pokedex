import 'package:bloc_pagination/core/constants/app_spacing.dart';
import 'package:bloc_pagination/features/presentation/widgets/pokemon_filter/pokemon_filter_button.dart';
import 'package:bloc_pagination/features/presentation/widgets/pokemon_filter/pokemon_filter_divider.dart';
import 'package:bloc_pagination/features/presentation/widgets/pokemon_filter/pokemon_filter_list.dart';
import 'package:bloc_pagination/features/presentation/widgets/pokemon_image_header.dart';
import 'package:bloc_pagination/features/presentation/widgets/pokemons_listing/pokemon_listing.dart';
import 'package:flutter/material.dart';

class PokemonsScreen extends StatelessWidget {
  const PokemonsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.screenPadding),
              child: PokemonImageHeader(),
            ),
            const SizedBox(
              height: AppSpacing.lg,
            ),
            Padding(
              padding: const EdgeInsets.only(left: AppSpacing.screenPadding),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  PokemonFilterButton(),
                  PokemonFilterDivider(),
                  PokemonFilterList(),
                ],
              ),
            ),
            const SizedBox(
              height: AppSpacing.lg,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.screenPadding),
                child: PokemonListing(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
