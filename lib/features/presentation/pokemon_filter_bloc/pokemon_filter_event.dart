part of 'pokemon_filter_bloc.dart';

sealed class PokemonFilterEvent extends Equatable {
  const PokemonFilterEvent();

  @override
  List<Object> get props => [];
}

class ToggleFilter extends PokemonFilterEvent {
  final bool? showFavorites;
  final Set<String>? types;

  const ToggleFilter({this.showFavorites, this.types});
}

class RemoveFilter extends PokemonFilterEvent {
  final String filterKey;
  final String valueToRemove;

  const RemoveFilter({required this.filterKey, required this.valueToRemove});
}

class RemoveAllFilters extends PokemonFilterEvent {}
