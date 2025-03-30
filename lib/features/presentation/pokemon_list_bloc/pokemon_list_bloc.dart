import 'package:bloc/bloc.dart';
import 'package:bloc_pagination/features/domain/entities/pokemon_entity.dart';
import 'package:equatable/equatable.dart';

import 'package:bloc_pagination/features/domain/repositories/pokemon_repositories.dart';

part 'pokemon_list_event.dart';
part 'pokemon_list_state.dart';

class PokemonListBloc extends Bloc<PokemonListEvent, PokemonListState> {
  final List<PokemonEntity> pokemonList = [];
  int pagination = 0;
  int offset = 0;
  final int limit = 30;

  PokemonListBloc() : super(PokemonListInitial()) {
    on<InitialFetch>(_onInitialPokemonFetch);
    on<FetchNextPage>(_onFetchNextPage);
    on<ToggleFavoriteStatus>(_onToggleFavoriteStatus);
  }

  void _onInitialPokemonFetch(
      InitialFetch event, Emitter<PokemonListState> emit) async {
    emit(PokemonListLoading());
    await _fetchPokemons(emit, chosenLimit: event.firstPokemon);
    await _fetchPokemons(emit);
    await _fetchPokemons(emit);
    await _fetchPokemons(emit);
  }

  void _onFetchNextPage(
      FetchNextPage event, Emitter<PokemonListState> emit) async {
    await _fetchPokemons(emit);
  }

  void _onToggleFavoriteStatus(
      ToggleFavoriteStatus event, Emitter<PokemonListState> emit) {
    pagination++;

    for (int i = 0; i < pokemonList.length; i++) {
      if (pokemonList[i].id == event.pokemonId) {
        final updated = pokemonList[i].copyWith(
          isFavorite: !pokemonList[i].isFavorite,
        );
        pokemonList[i] = updated;
        break;
      }
    }

    emit(PokemonListSuccess(pokemons: pokemonList, pagination: pagination));
  }

  Future<void> _fetchPokemons(Emitter<PokemonListState> emit,
      {int? chosenLimit}) async {
    try {
      final List<String> pokemonUrls = await PokemonRepositories()
          .fetchPokemonUrls(limit: chosenLimit ?? limit, offset: offset);

      if (pokemonUrls.isNotEmpty) {
        final List<PokemonEntity?> fetchedPokemons = await Future.wait(
            pokemonUrls
                .map((url) => PokemonRepositories().fetchPokemonDetails(url)));

        pokemonList.addAll(fetchedPokemons.whereType<PokemonEntity>());

        pagination++;
        offset += chosenLimit ?? limit;

        emit(PokemonListSuccess(pokemons: pokemonList, pagination: pagination));
      } else {
        emit(PokemonListError(message: "There are no more pokemons"));
      }
    } catch (e) {
      emit(PokemonListError(
          message: "Failed to fetch Pokémon: ${e.toString()}"));
    }
  }
}
