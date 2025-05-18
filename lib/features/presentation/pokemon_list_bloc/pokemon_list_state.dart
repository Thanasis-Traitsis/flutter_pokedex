part of 'pokemon_list_bloc.dart';

sealed class PokemonListState extends Equatable {
  const PokemonListState();

  @override
  List<Object> get props => [];
}

final class PokemonListInitial extends PokemonListState {}

final class PokemonListLoading extends PokemonListState {}

final class PokemonListSuccess extends PokemonListState {
  final Map<String, PokemonEntity> pokemonMap;
  final int pagination;
  final int favoritePokemons;
  final PokemonFilterState filterState;

  const PokemonListSuccess({
    required this.pokemonMap,
    this.pagination = 0,
    this.favoritePokemons = 0,
    required this.filterState,
  });

  List<PokemonEntity> getPokemons() {
    return PokemonDisplayHelper.getDisplayedPokemons(
      pokemon: pokemonMap,
      filterEntity: filterState.selectedFilters,
    );
  }

  @override
  List<Object> get props => [
        pokemonMap,
        pagination,
        favoritePokemons,
      ];
}

final class PokemonListError extends PokemonListState {
  final String message;

  const PokemonListError({required this.message});

  @override
  List<Object> get props => [message];
}
