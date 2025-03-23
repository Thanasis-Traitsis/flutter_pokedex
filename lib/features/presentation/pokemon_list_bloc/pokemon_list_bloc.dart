import 'package:bloc/bloc.dart';
import 'package:bloc_pagination/features/domain/entities/pokemon_entity.dart';
import 'package:equatable/equatable.dart';

import 'package:bloc_pagination/features/domain/repositories/pokemon_repositories.dart';

part 'pokemon_list_event.dart';
part 'pokemon_list_state.dart';

class PokemonListBloc extends Bloc<PokemonListEvent, PokemonListState> {
  PokemonListBloc() : super(PokemonListInitial()) {
    on<InitialFetch>(_onInitialPokemonFetch);
    on<ToggleFavoriteStatus>(_onToggleFavoriteStatus);
  }

  final List<PokemonEntity> pokemonList = [];

  void _onInitialPokemonFetch(
      InitialFetch event, Emitter<PokemonListState> emit) async {
    emit(PokemonListLoading());

    try {
      final List<String> pokemonUrls =
          await PokemonRepositories().fetchPokemonUrls(event.firstPokemon);

      if (pokemonUrls.isNotEmpty) {
        final List<PokemonEntity?> fetchedPokemons = await Future.wait(
            pokemonUrls
                .map((url) => PokemonRepositories().fetchPokemonDetails(url)));

        pokemonList.addAll(fetchedPokemons.whereType<PokemonEntity>());

        emit(PokemonListSuccess(pokemons: pokemonList));
      } else {
        emit(PokemonListError(message: "There are no more pokemons"));
      }
    } catch (e) {
      emit(PokemonListError(
          message: "Failed to fetch Pokémon: ${e.toString()}"));
    }
  }

  void _onToggleFavoriteStatus(
      ToggleFavoriteStatus event, Emitter<PokemonListState> emit) {
    if (state is PokemonListSuccess) {
      final currentState = state as PokemonListSuccess;

      final updatedList = currentState.pokemons.map((pokemon) {
        if (pokemon.id == event.pokemonId) {
          return pokemon.copyWith(isFavorite: !pokemon.isFavorite);
        }
        return pokemon;
      }).toList();

      emit(PokemonListSuccess(pokemons: updatedList));
    }
  }
}
