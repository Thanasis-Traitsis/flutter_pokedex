import 'package:bloc_pagination/core/constants/app_spacing.dart';
import 'package:bloc_pagination/features/presentation/helpers/filter_chips_helper.dart';
import 'package:bloc_pagination/features/presentation/pokemon_filter_bloc/pokemon_filter_bloc.dart';
import 'package:bloc_pagination/features/presentation/widgets/pokemon_filter/pokemon_filter_delete_button.dart';
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
            final List<Widget> filterChips = FilterChipsHelper()
                .updateFilterChips(selectedFilters: state.selectedFilters);

            if (filterChips.length > 1) {
              filterChips.add(PokemonFilterDeleteButton());
            }

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
