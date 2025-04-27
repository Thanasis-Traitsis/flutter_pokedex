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
  final bool showOnlyFavorites;
  final Set<String> selectedTypes;

  const PokemonListSuccess({
    required this.pokemonMap,
    this.pagination = 0,
    this.favoritePokemons = 0,
    this.showOnlyFavorites = false,
    this.selectedTypes = const {},
  });

  List<PokemonEntity> getDisplayedPokemons(
      {SortOption sortBy = SortOption.id}) {
    List<PokemonEntity> pokemons;

    if (!showOnlyFavorites && selectedTypes.isEmpty) {
      pokemons = pokemonMap.values.toList();
    } else {
      pokemons = pokemonMap.values.where((pokemon) {
        bool matchesFavorite = !showOnlyFavorites || pokemon.isFavorite;
        bool matchesType = selectedTypes.isEmpty ||
            pokemon.types.any((type) => selectedTypes.contains(type.name));

        return matchesFavorite && matchesType;
      }).toList();
    }

    switch (sortBy) {
      case SortOption.id:
        pokemons.sort((a, b) => int.parse(a.id).compareTo(int.parse(b.id)));
        break;
      case SortOption.name:
        pokemons.sort((a, b) => a.name.compareTo(b.name));
        break;
      case SortOption.type:
        pokemons
            .sort((a, b) => a.types.first.name.compareTo(b.types.first.name));
        break;
    }

    return pokemons;
  }

  @override
  List<Object> get props => [
        pokemonMap,
        pagination,
        favoritePokemons,
        showOnlyFavorites,
        selectedTypes
      ];
}

final class PokemonListError extends PokemonListState {
  final String message;

  const PokemonListError({required this.message});

  @override
  List<Object> get props => [message];
}
