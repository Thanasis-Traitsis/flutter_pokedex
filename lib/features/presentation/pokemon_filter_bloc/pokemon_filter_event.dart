part of 'pokemon_filter_bloc.dart';

sealed class PokemonFilterEvent extends Equatable {
  const PokemonFilterEvent();

  @override
  List<Object> get props => [];
}

class ToggleFavoriteFilter extends PokemonFilterEvent {}

class ToggleTypeFilter extends PokemonFilterEvent {
  final Set<String> types;

  const ToggleTypeFilter(this.types);

  @override
  List<Object> get props => [types];
}


class RemoveFilter extends PokemonFilterEvent {
  final String filterKey;
  final String valueToRemove;

  const RemoveFilter({required this.filterKey, required this.valueToRemove});
}
