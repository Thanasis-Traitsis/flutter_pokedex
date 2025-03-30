part of 'pokemon_list_bloc.dart';

sealed class PokemonListState extends Equatable {
  const PokemonListState();

  @override
  List<Object> get props => [];
}

final class PokemonListInitial extends PokemonListState {}

final class PokemonListLoading extends PokemonListState {}

final class PokemonListSuccess extends PokemonListState {
  final List<PokemonEntity> pokemons;
  final int pagination;

  const PokemonListSuccess({required this.pokemons, required this.pagination});

  @override
  List<Object> get props => [pagination];
}

final class PokemonListError extends PokemonListState {
  final String message;

  const PokemonListError({required this.message});

  @override
  List<Object> get props => [message];
}
