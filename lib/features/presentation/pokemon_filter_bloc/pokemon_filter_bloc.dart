import 'package:bloc/bloc.dart';
import 'package:bloc_pagination/features/domain/entities/pokemon_filter_entity.dart';
import 'package:equatable/equatable.dart';

part 'pokemon_filter_event.dart';
part 'pokemon_filter_state.dart';

class PokemonFilterBloc extends Bloc<PokemonFilterEvent, PokemonFilterState> {
  PokemonFilterBloc() : super(const PokemonFilterState()) {
    on<UpdateFilter>(_onUpdateFilter);
    on<RemoveFilter>(_onRemoveFilter);
    on<RemoveAllFilters>(_onRemoveAllFilters);
  }

  void _onUpdateFilter(UpdateFilter event, Emitter<PokemonFilterState> emit) {
    final PokemonFiltersEntity updatedFilters =
        state.selectedFilters.updateFilter(event.filter, event.value);

    emit(state.copyWith(selectedFilters: updatedFilters));
  }

  void _onRemoveFilter(RemoveFilter event, Emitter<PokemonFilterState> emit) {
    final PokemonFiltersEntity updatedFilters = state.selectedFilters
        .removeFilterValue(event.filterKey, event.valueToRemove);

    emit(state.copyWith(selectedFilters: updatedFilters));
  }

  void _onRemoveAllFilters(
      RemoveAllFilters event, Emitter<PokemonFilterState> emit) {
    emit(state.copyWith(selectedFilters: PokemonFiltersEntity()));
  }
}
