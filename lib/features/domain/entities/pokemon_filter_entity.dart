enum PokemonFilterType {
  favorite,
  types,
}

class PokemonFiltersEntity {
  final bool showFavorites;
  final Set<String> types;

  const PokemonFiltersEntity({
    this.showFavorites = false,
    Set<String>? types,
  }) : types = types ?? const {};

  PokemonFiltersEntity copyWith({
    bool? showFavorites,
    Set<String>? types,
  }) {
    return PokemonFiltersEntity(
      showFavorites: showFavorites ?? this.showFavorites,
      types: types ?? this.types,
    );
  }

  PokemonFiltersEntity updateFilter<T>(PokemonFilterType type, T value) {
    switch (type) {
      case PokemonFilterType.favorite:
        return copyWith(showFavorites: value as bool?);
      case PokemonFilterType.types:
        return copyWith(types: value as Set<String>?);
    }
  }

  PokemonFiltersEntity removeFilterValue(PokemonFilterType type, String value) {
    switch (type) {
      case PokemonFilterType.types:
        if (types.isEmpty) return this;

        final updatedTypes = Set<String>.from(types)..remove(value);

        return updatedTypes.isEmpty
            ? clearFilter(type)
            : copyWith(types: updatedTypes);
      default:
        return clearFilter(type);
    }
  }

  PokemonFiltersEntity clearFilter(PokemonFilterType type) {
    switch (type) {
      case PokemonFilterType.favorite:
        return copyWith(showFavorites: false);
      case PokemonFilterType.types:
        return copyWith(types: {});
    }
  }

  bool get isEmpty => showFavorites == false && types.isEmpty;

  bool get isNotEmpty => !isEmpty;
}
