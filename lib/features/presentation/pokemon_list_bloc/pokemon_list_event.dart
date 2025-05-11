part of 'pokemon_list_bloc.dart';

sealed class PokemonListEvent extends Equatable {
  const PokemonListEvent();

  @override
  List<Object> get props => [];
}

class InitialFetch extends PokemonListEvent {
  final int firstPokemon;

  const InitialFetch(this.firstPokemon);
}

class FetchNextPage extends PokemonListEvent {}

class ToggleFavoriteStatus extends PokemonListEvent {
  final String pokemonId;

  const ToggleFavoriteStatus(this.pokemonId);

  @override
  List<Object> get props => [pokemonId];
}

class ApplyFilters extends PokemonListEvent {}
