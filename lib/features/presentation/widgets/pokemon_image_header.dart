import 'package:bloc_pagination/core/constants/app_spacing.dart';
import 'package:bloc_pagination/core/constants/app_values.dart';
import 'package:flutter/material.dart';

class PokemonImageHeader extends StatelessWidget {
  const PokemonImageHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: AppValues.homeImageHeaderSize,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
      child: Image(
        image: AssetImage("assets/images/pokemon.png"),
      ),
    );
  }
}
