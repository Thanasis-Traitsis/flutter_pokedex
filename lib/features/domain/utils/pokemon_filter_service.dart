import 'package:bloc_pagination/core/constants/api/api_constants.dart';
import 'package:bloc_pagination/core/utils/url_utils.dart';
import 'package:bloc_pagination/features/domain/entities/pokemon_entity.dart';
import 'package:bloc_pagination/features/domain/entities/pokemon_filter_entity.dart';
import 'package:bloc_pagination/features/domain/repositories/pokemon_repositories.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PokemonFilterService {
  final SharedPreferences prefs;
  final List<String> favoriteIds;

  PokemonFilterService({required this.prefs, required this.favoriteIds});

  Future<Map<String, PokemonEntity>> applyFilters({
    required Map<String, PokemonEntity> pokemonMap,
    required Map<String, PokemonEntity> filteredMap,
    required PokemonFiltersEntity selectedFilters,
  }) async {
    Map<String, PokemonEntity> resultMap = Map.from(filteredMap);

    if (selectedFilters.showFavorites) {
      await _loadUnloadedFavoritePokemons(resultMap);
    } else if (selectedFilters.types.isNotEmpty) {
      await _loadPokemonsBySelectedTypes(resultMap, selectedFilters.types);
    }

    return resultMap;
  }

  Future<void> _loadUnloadedFavoritePokemons(
      Map<String, PokemonEntity> filteredMap) async {
    final unloadedIds = favoriteIds.where((id) => !filteredMap.containsKey(id));

    if (unloadedIds.isEmpty) return;

    final List<PokemonEntity> fetchedPokemon =
        await _fetchPokemonEntitiesByIds(unloadedIds);
    for (var pokemon in fetchedPokemon) {
      filteredMap[pokemon.id] = pokemon;
    }
  }

  Future<void> _loadPokemonsBySelectedTypes(
      Map<String, PokemonEntity> filteredMap, Set<String> types) async {
         
    final urls = await PokemonRepositories().getPokemonUrlFromType(
      favoriteIds: favoriteIds,
      types: types,
    );

    final idsToFetch = _extractPokemonIdsFromUrls(urls)
        .where((id) => !filteredMap.containsKey(id));

    final fetched = await _fetchPokemonEntitiesByIds(idsToFetch);
    
    for (var pokemon in fetched) {
      filteredMap[pokemon.id] = pokemon;
    }
  }

  Future<List<PokemonEntity>> _fetchPokemonEntitiesByIds(
      Iterable<String> ids) async {
    final results = await Future.wait(ids.map((id) {
      return PokemonRepositories().fetchPokemonDetails(
        pokemonUrl: ApiConstants.pokemonDetails(id),
        favoritePokemons: favoriteIds,
      );
    }));

    return results.whereType<PokemonEntity>().toList();
  }

  Iterable<String> _extractPokemonIdsFromUrls(Set<String> urls) {
    return urls.map((url) {
      return UrlUtils.extractId(url);
    });
  }
}
