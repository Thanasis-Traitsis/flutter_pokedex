import 'package:bloc_pagination/core/constants/app_spacing.dart';
import 'package:bloc_pagination/features/presentation/widgets/pokemon_filter/pokemon_filter_selected_item.dart';
import 'package:flutter/material.dart';

class PokemonFilterList extends StatelessWidget {
  const PokemonFilterList({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(
            4,
            (index) => Padding(
              padding: EdgeInsets.only(
                  left: index == 0 ? AppSpacing.md : AppSpacing.xs,
                  right: index < 4 - 1 ? 0 : AppSpacing.screenPadding),
              child: PokemonFilterSelectedItem(),
            ),
          ),
        ),
      ),
    );
  }
}
