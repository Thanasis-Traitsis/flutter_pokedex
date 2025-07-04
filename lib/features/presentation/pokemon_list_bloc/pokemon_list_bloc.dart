import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:bloc_pagination/core/constants/app_strings.dart';
import 'package:bloc_pagination/features/domain/entities/pokemon_entity.dart';
import 'package:bloc_pagination/features/domain/utils/pokemon_filter_service.dart';
import 'package:bloc_pagination/features/presentation/helpers/pokemon_display_helper.dart';
import 'package:bloc_pagination/features/presentation/pokemon_filter_bloc/pokemon_filter_bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:bloc_pagination/features/domain/repositories/pokemon_repositories.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'pokemon_list_event.dart';
part 'pokemon_list_state.dart';

class PokemonListBloc extends Bloc<PokemonListEvent, PokemonListState> {
  final PokemonFilterBloc filterBloc;
  late final StreamSubscription filterSubscription;
  late final SharedPreferences prefs;
  late final List<String> favoriteIds;
  late final PokemonFilterService filterService;

  final Map<String, PokemonEntity> pokemonMap = {};
  Map<String, PokemonEntity> filteredMap = {};
  int pagination = 0;
  int offset = 0;
  final int limit = 30;

  bool canFetchMore = true;
  bool isFiltering = false;

  PokemonListBloc(this.filterBloc) : super(PokemonListInitial()) {
    filterSubscription = filterBloc.stream.listen((filterState) {
      if (filterState.selectedFilters.isNotEmpty) {
        isFiltering = true;
        if (filteredMap.isEmpty) {
          filteredMap = Map.from(pokemonMap);
        }
      } else {
        isFiltering = false;
      }

      add(ApplyFilters());
    });

    on<InitialFetch>(_onInitialPokemonFetch);
    on<FetchNextPage>(_onFetchNextPage);
    on<ToggleFavoriteStatus>(_onToggleFavoriteStatus);
    on<ApplyFilters>(_onApplyFilters);
  }

  void _onInitialPokemonFetch(
      InitialFetch event, Emitter<PokemonListState> emit) async {
    prefs = await SharedPreferences.getInstance();
    favoriteIds = prefs.getStringList(AppStrings.prefsFavoritePokemonIds) ?? [];
    filterService =
        PokemonFilterService(prefs: prefs, favoriteIds: favoriteIds);

    emit(PokemonListLoading());
    await _fetchPokemons(emit, chosenLimit: event.firstPokemon);
    await _fetchPokemons(emit);
    await _fetchPokemons(emit);
    await _fetchPokemons(emit);
  }

  void _onFetchNextPage(
      FetchNextPage event, Emitter<PokemonListState> emit) async {
    if (!isFiltering) {
      await _fetchPokemons(emit);
    }
  }

  Future<void> _fetchPokemons(Emitter<PokemonListState> emit,
      {int? chosenLimit}) async {
    if (canFetchMore) {
      try {
        final List<String> pokemonUrls = await PokemonRepositories()
            .fetchPokemonUrls(limit: chosenLimit ?? limit, offset: offset);

        if (pokemonUrls.isNotEmpty) {
          final List<PokemonEntity?> fetchedPokemons = await Future.wait(
              pokemonUrls.map((url) => PokemonRepositories()
                  .fetchPokemonDetails(
                      pokemonUrl: url, favoritePokemons: favoriteIds)));

          for (var pokemon in fetchedPokemons.whereType<PokemonEntity>()) {
            pokemonMap[pokemon.id] = pokemon;
          }

          pagination++;
          offset += chosenLimit ?? limit;

          _emitSuccessState(emit);
        } else {
          canFetchMore = false;
        }
      } catch (e) {
        emit(PokemonListError(
            message: "${AppStrings.failedToFetch}: ${e.toString()}"));
      }
    }
  }

  void _onToggleFavoriteStatus(
      ToggleFavoriteStatus event, Emitter<PokemonListState> emit) async {
    final Map<String, PokemonEntity> currentMap =
        isFiltering ? filteredMap : pokemonMap;
    try {
      if (currentMap.containsKey(event.pokemonId)) {
        final pokemon = currentMap[event.pokemonId]!;
        final updatedPokemon =
            pokemon.copyWith(isFavorite: !pokemon.isFavorite);

        if (pokemonMap.containsKey(event.pokemonId)) {
          pokemonMap[event.pokemonId] = updatedPokemon;
        }

        if (filteredMap.containsKey(event.pokemonId)) {
          filteredMap[event.pokemonId] = updatedPokemon;
        }

        if (updatedPokemon.isFavorite) {
          favoriteIds.add(event.pokemonId);
          _sortListOfStrings(favoriteIds);
        } else {
          favoriteIds.remove(event.pokemonId);
        }

        await prefs.setStringList(
            AppStrings.prefsFavoritePokemonIds, favoriteIds);

        _emitSuccessState(emit,
            currentMap: isFiltering ? filteredMap : pokemonMap);
      }
    } catch (e) {
      emit(PokemonListError(
          message: "Failed to update favorite status: ${e.toString()}"));
    }
  }

  void _onApplyFilters(
      ApplyFilters event, Emitter<PokemonListState> emit) async {
    emit(PokemonListLoading());

    try {
      if (isFiltering) {
        filteredMap = await filterService.applyFilters(
          pokemonMap: pokemonMap,
          filteredMap: filteredMap,
          selectedFilters: filterBloc.state.selectedFilters,
        );
      }

      _emitSuccessState(
        emit,
        currentMap: isFiltering ? filteredMap : pokemonMap,
      );
    } catch (e) {
      emit(PokemonListError(
          message: "${AppStrings.failedToLoad}: ${e.toString()}"));
    }
  }

  void _emitSuccessState(Emitter<PokemonListState> emit,
      {Map<String, PokemonEntity>? currentMap}) {
    emit(PokemonListSuccess(
      pokemonMap: currentMap ?? pokemonMap,
      pagination: pagination,
      favoritePokemons: favoriteIds.length,
      filterState: filterBloc.state,
    ));
  }

  @override
  Future<void> close() {
    filterSubscription.cancel();
    return super.close();
  }

  void _sortListOfStrings(List<String> list) {
    list.sort((a, b) {
      return int.parse(a).compareTo(int.parse(b));
    });
  }
}
