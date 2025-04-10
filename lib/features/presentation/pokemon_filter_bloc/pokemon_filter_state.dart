part of 'pokemon_filter_bloc.dart';

final class PokemonFilterState extends Equatable {
  final Set<String> selectedFilters;

  const PokemonFilterState({this.selectedFilters = const {}});

  PokemonFilterState copyWith({Set<String>? selectedFilters}) {
    return PokemonFilterState(
      selectedFilters: selectedFilters ?? this.selectedFilters,
    );
  }

  @override
  List<Object> get props => [selectedFilters];
}
