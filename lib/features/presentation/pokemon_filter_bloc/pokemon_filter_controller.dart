import 'package:bloc_pagination/features/domain/entities/pokemon_filter_entity.dart';
import 'package:bloc_pagination/features/presentation/pokemon_filter_bloc/pokemon_filter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PokemonFilterController {
  bool showOnlyFavorites;
  Set<String> selectedPokemonTypes;

  PokemonFilterController(PokemonFilterState state)
      : showOnlyFavorites = state.selectedFilters.showFavorites,
        selectedPokemonTypes = Set<String>.from(state.selectedFilters.types);

  void applyFilters(BuildContext context) {
    final bloc = context.read<PokemonFilterBloc>();
    final state = bloc.state;

    if(_valueHasChange(state.selectedFilters.showFavorites, showOnlyFavorites)) {
      bloc.add(UpdateFilter(filter: PokemonFilterType.favorite, value: showOnlyFavorites));
    }

    if(_valueHasChange(state.selectedFilters.types, selectedPokemonTypes)){
      bloc.add(UpdateFilter(filter: PokemonFilterType.types, value: selectedPokemonTypes));
    }
  }

  bool _valueHasChange<T>(T oldvalue, T newValue) {
    return oldvalue != newValue;
  }
}
