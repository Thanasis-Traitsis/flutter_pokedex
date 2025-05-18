part of 'pokemon_filter_bloc.dart';

sealed class PokemonFilterEvent extends Equatable {
  const PokemonFilterEvent();

  @override
  List<Object> get props => [];
}

class UpdateFilter<T> extends PokemonFilterEvent {
  final PokemonFilterType filter;
  final T value;

  const UpdateFilter({required this.filter,required this.value});
}

class RemoveFilter extends PokemonFilterEvent {
  final PokemonFilterType filterKey;
  final String valueToRemove;

  const RemoveFilter({required this.filterKey, required this.valueToRemove});
}

class RemoveAllFilters extends PokemonFilterEvent {}
