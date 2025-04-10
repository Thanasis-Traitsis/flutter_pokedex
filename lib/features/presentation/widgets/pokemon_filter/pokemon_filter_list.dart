import 'package:bloc_pagination/core/constants/app_spacing.dart';
import 'package:bloc_pagination/features/presentation/pokemon_filter_bloc/pokemon_filter_bloc.dart';
import 'package:bloc_pagination/features/presentation/widgets/pokemon_filter/pokemon_filter_selected_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PokemonFilterList extends StatelessWidget {
  const PokemonFilterList({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: BlocBuilder<PokemonFilterBloc, PokemonFilterState>(
          builder: (context, state) {
            return Row(
              children: List.generate(
                state.selectedFilters.length,
                (index) => Padding(
                  padding: EdgeInsets.only(
                      left: index == 0 ? AppSpacing.md : AppSpacing.xs,
                      right: index < state.selectedFilters.length - 1
                          ? 0
                          : AppSpacing.screenPadding),
                  child: PokemonFilterSelectedItem(filterTitle: state.selectedFilters[index]),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
