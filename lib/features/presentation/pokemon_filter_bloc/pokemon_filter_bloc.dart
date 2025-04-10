import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'pokemon_filter_event.dart';
part 'pokemon_filter_state.dart';

class PokemonFilterBloc extends Bloc<PokemonFilterEvent, PokemonFilterState> {
  PokemonFilterBloc() : super(const PokemonFilterState()) {
    on<ToggleFilter>(_onToggleFilter);
  }

  void _onToggleFilter(ToggleFilter event, Emitter<PokemonFilterState> emit) {
    final filters = Set<String>.from(state.selectedFilters);

    if (filters.contains(event.filter)) {
      filters.remove(event.filter);
    } else {
      filters.add(event.filter);
    }

    emit(state.copyWith(selectedFilters: filters));
  }
}
