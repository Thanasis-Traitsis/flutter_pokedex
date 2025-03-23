import 'package:bloc_pagination/core/constants/app_values.dart';
import 'package:bloc_pagination/core/constants/app_spacing.dart';
import 'package:bloc_pagination/core/widgets/shimmer_widget.dart';
import 'package:flutter/material.dart';

class PokemonListingLoadingItem extends StatelessWidget {
  const PokemonListingLoadingItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ShimmerWidget(
          width: AppValues.pokemonImageSize,
          height: AppValues.pokemonImageSize,
        ),
        SizedBox(
          width: AppSpacing.md,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ShimmerWidget(
                width: double.infinity,
                height: AppValues.pokemonImageSize / 4,
              ),
              SizedBox(
                height: AppSpacing.md,
              ),
              Row(
                children: [
                  ShimmerWidget(
                    width: AppValues.pokemonImageSize / 2,
                    height: AppValues.pokemonImageSize / 4,
                  ),
                  SizedBox(
                    width: AppSpacing.md,
                  ),
                  ShimmerWidget(
                    width: AppValues.pokemonImageSize / 2,
                    height: AppValues.pokemonImageSize / 4,
                  ),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
}
