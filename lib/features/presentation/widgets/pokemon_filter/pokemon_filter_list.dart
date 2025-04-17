import 'package:bloc_pagination/core/constants/app_spacing.dart';
import 'package:bloc_pagination/core/utils/filter_chip_utils.dart';
import 'package:bloc_pagination/features/presentation/pokemon_filter_bloc/pokemon_filter_bloc.dart';
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
            final List<Widget> filterChips = [];

            print(filterChips);

            state.selectedFilters.entries.forEach((filter) {
              if (filter.value is Iterable) {
                for (String val in filter.value) {
                  filterChips.add(Padding(
                    padding: EdgeInsets.only(
                      left: filterChips.isEmpty ? AppSpacing.md : AppSpacing.xs,
                    ),
                    child: shapeFilterChip(key: filter.key, value: val),
                  ));
                }
              } else {
                filterChips.add(Padding(
                  padding: EdgeInsets.only(
                    left: filterChips.isEmpty ? AppSpacing.md : AppSpacing.xs,
                  ),
                  child: shapeFilterChip(key: filter.key, value: filter.value),
                ));
              }
            });

            return Padding(
              padding: const EdgeInsets.only(right: AppSpacing.screenPadding),
              child: Row(
                children: filterChips,
              ),
            );
          },
        ),
      ),
    );
  }
}
