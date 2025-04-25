import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:bloc_pagination/core/constants/api/api_constants.dart';
import 'package:bloc_pagination/core/constants/app_strings.dart';
import 'package:bloc_pagination/features/domain/entities/pokemon_entity.dart';
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

  final Map<String, PokemonEntity> pokemonMap = {};
  int pagination = 0;
  int offset = 0;
  final int limit = 30;

  bool canFetchMore = true;
  bool showOnlyFavorites = false;
  Set<String> selectedTypes = {};

  PokemonListBloc(this.filterBloc) : super(PokemonListInitial()) {
    filterSubscription = filterBloc.stream.listen((filterState) {
      showOnlyFavorites =
          filterState.selectedFilters[AppStrings.filterStateFavoriteKey] ??
              false;
      selectedTypes =
          filterState.selectedFilters[AppStrings.filterStateTypesKey] ?? {};

      add(ApplyFilters(
        showFavorites: showOnlyFavorites,
        types: selectedTypes,
      ));
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
    try {
      if (pokemonMap.containsKey(event.pokemonId)) {
        final pokemon = pokemonMap[event.pokemonId]!;

        final updatedPokemon =
            pokemon.copyWith(isFavorite: !pokemon.isFavorite);

        pokemonMap[event.pokemonId] = updatedPokemon;

        if (updatedPokemon.isFavorite) {
          favoriteIds.add(event.pokemonId);
          _sortFavoriteIds();
        } else {
          favoriteIds.remove(event.pokemonId);
        }

        await prefs.setStringList(
            AppStrings.prefsFavoritePokemonIds, favoriteIds);

        _emitSuccessState(emit);
      }
    } catch (e) {
      emit(PokemonListError(
          message: "Failed to update favorite status: ${e.toString()}"));
    }
  }

  void _onApplyFilters(
      ApplyFilters event, Emitter<PokemonListState> emit) async {
    emit(PokemonListLoading());

    if (showOnlyFavorites) {
      final unloadedFavoriteIds =
          favoriteIds.where((id) => !pokemonMap.containsKey(id));

      if (unloadedFavoriteIds.isNotEmpty) {
        try {
          final List<PokemonEntity?> fetchedPokemons =
              await Future.wait(unloadedFavoriteIds.map((id) {
            final String url = ApiConstants.pokemonDetails(id);
            return PokemonRepositories().fetchPokemonDetails(
                pokemonUrl: url, favoritePokemons: favoriteIds);
          }));

          for (var pokemon in fetchedPokemons.whereType<PokemonEntity>()) {
            pokemonMap[pokemon.id] = pokemon;
          }
        } catch (e) {
          emit(PokemonListError(
              message: "Failed to load all favorite Pokemon: ${e.toString()}"));
          return;
        }
      }
    } else if (selectedTypes.isNotEmpty && !showOnlyFavorites) {
      final List<String> pokemonUrls =
          await PokemonRepositories().getPokemonUrlFromType(
        favoriteIds: favoriteIds,
        types: selectedTypes,
      );

      final Set<String> extractUrls = {};
      for (String url in pokemonUrls) {
        final cleanUrl = url.substring(0, url.length - 1);

        final segments = cleanUrl.split('/');
        final lastSegment = segments.last;

        if (!pokemonMap.keys.contains(lastSegment)) {
          extractUrls.add(url);
        }
      }

      final List<PokemonEntity?> fetchedPokemons =
          await Future.wait(extractUrls.map((url) {
        return PokemonRepositories().fetchPokemonDetails(
            pokemonUrl: url, favoritePokemons: favoriteIds);
      }));

      for (var pokemon in fetchedPokemons.whereType<PokemonEntity>()) {
        pokemonMap[pokemon.id] = pokemon;
      }
    }

    _emitSuccessState(emit);
  }

  void _emitSuccessState(Emitter<PokemonListState> emit) {
    emit(PokemonListSuccess(
      pokemonMap: pokemonMap,
      pagination: pagination,
      favoritePokemons: favoriteIds.length,
      showOnlyFavorites: showOnlyFavorites,
      selectedTypes: selectedTypes,
    ));
  }

  @override
  Future<void> close() {
    filterSubscription.cancel();
    return super.close();
  }

  void _sortFavoriteIds() {
    favoriteIds.sort((a, b) {
      return int.parse(a).compareTo(int.parse(b));
    });
  }
}
