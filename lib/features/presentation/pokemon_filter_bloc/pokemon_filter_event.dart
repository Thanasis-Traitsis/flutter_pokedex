part of 'pokemon_filter_bloc.dart';

sealed class PokemonFilterEvent extends Equatable {
  const PokemonFilterEvent();

  @override
  List<Object> get props => [];
}

final class ToggleFilter extends PokemonFilterEvent {
  final String filter;

  const ToggleFilter(this.filter);
}

final class ClearFilters extends PokemonFilterEvent {}