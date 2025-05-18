part of 'pokemon_filter_bloc.dart';

final class PokemonFilterState extends Equatable {
  final PokemonFiltersEntity selectedFilters;

  const PokemonFilterState({this.selectedFilters = const PokemonFiltersEntity(types: {})});

  PokemonFilterState copyWith({PokemonFiltersEntity? selectedFilters}) {
    return PokemonFilterState(
      selectedFilters: selectedFilters ?? this.selectedFilters,
    );
  }

  @override
  List<Object> get props => [selectedFilters];
}
