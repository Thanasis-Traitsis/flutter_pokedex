import 'package:bloc_pagination/core/constants/sort_options.dart';
import 'package:bloc_pagination/features/domain/entities/pokemon_entity.dart';
import 'package:bloc_pagination/features/domain/entities/pokemon_filter_entity.dart';

class PokemonDisplayHelper {
  static List<PokemonEntity> getDisplayedPokemons({
    required Map<String, PokemonEntity> pokemon,
    required PokemonFiltersEntity filterEntity,
    SortOption sortBy = SortOption.id,
  }) {
    List<PokemonEntity> filtered = pokemon.values.where((pokemon) {
      final matchesFavorite = !filterEntity.showFavorites || pokemon.isFavorite;
      final matchesType = filterEntity.types.isEmpty ||
          pokemon.types.any((type) => filterEntity.types.contains(type.name));

      return matchesFavorite && matchesType;
    }).toList();

    _sortPokemon(filtered, sortBy);

    return filtered;
  }

  static void _sortPokemon(List<PokemonEntity> list, SortOption sortBy) {
    switch (sortBy) {
      case SortOption.id:
        list.sort((pokemonA, pokemonB) =>
            int.parse(pokemonA.id).compareTo(int.parse(pokemonB.id)));
        break;
      case SortOption.name:
        list.sort(
            (pokemonA, pokemonB) => pokemonA.name.compareTo(pokemonB.name));
        break;
      case SortOption.type:
        list.sort((pokemonA, pokemonB) =>
            pokemonA.types.first.name.compareTo(pokemonB.types.first.name));
        break;
    }
  }
}
