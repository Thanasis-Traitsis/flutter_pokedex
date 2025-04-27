import 'package:bloc_pagination/core/constants/app_strings.dart';
import 'package:bloc_pagination/features/presentation/pokemon_filter_bloc/pokemon_filter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PokemonFilterController {
  bool showOnlyFavorites;
  Set<String> selectedPokemonTypes;

  PokemonFilterController(PokemonFilterState state)
      : showOnlyFavorites =
            state.selectedFilters[AppStrings.filterStateFavoriteKey] ?? false,
        selectedPokemonTypes = Set<String>.from(
            state.selectedFilters[AppStrings.filterStateTypesKey] ??
                const <String>{});

  void applyFilters(BuildContext context) {
    final bloc = context.read<PokemonFilterBloc>();
    final state = bloc.state;

    bool? showFavorites;

    if ((state.selectedFilters[AppStrings.filterStateFavoriteKey] ?? false) !=
        showOnlyFavorites) {
      showFavorites = showOnlyFavorites;
    }

    final Set<String> oldTypes =
        state.selectedFilters[AppStrings.filterStateTypesKey] ?? {};

    if (selectedPokemonTypes.isNotEmpty) {
      bloc.add(ToggleFilter(
          showFavorites: showFavorites, types: selectedPokemonTypes));
    } else if (selectedPokemonTypes.isEmpty && oldTypes.isNotEmpty) {
      bloc.add(ToggleFilter(
          showFavorites: showFavorites, types: selectedPokemonTypes));
    } else {
      bloc.add(ToggleFilter(showFavorites: showFavorites));
    }
  }
}
