part of 'pokemon_filter_bloc.dart';

final class PokemonFilterState extends Equatable {
  final Map<String, dynamic> selectedFilters;

  const PokemonFilterState({this.selectedFilters = const {}});

  PokemonFilterState copyWith({Map<String, dynamic>? selectedFilters}) {
    return PokemonFilterState(
      selectedFilters: selectedFilters ?? this.selectedFilters,
    );
  }

  @override
  List<Object> get props => [selectedFilters[AppStrings.filterStateTypesKey]];
}
