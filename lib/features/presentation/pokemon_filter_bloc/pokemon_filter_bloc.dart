import 'package:bloc/bloc.dart';
import 'package:bloc_pagination/core/constants/app_strings.dart';
import 'package:equatable/equatable.dart';

part 'pokemon_filter_event.dart';
part 'pokemon_filter_state.dart';

class PokemonFilterBloc extends Bloc<PokemonFilterEvent, PokemonFilterState> {
  PokemonFilterBloc() : super(const PokemonFilterState()) {
    on<ToggleFavoriteFilter>(_onToggleFavoriteFilter);
    on<ToggleTypeFilter>(_onToggleTypeFilter);
    on<RemoveFilter>(_onRemoveFilter);
  }

  void _onToggleFavoriteFilter(
    ToggleFavoriteFilter event,
    Emitter<PokemonFilterState> emit,
  ) {
    final currentValue =
        state.selectedFilters[AppStrings.filterStateFavoriteKey];

    final updatedFilters = Map<String, dynamic>.from(state.selectedFilters);

    if (currentValue == true) {
      updatedFilters[AppStrings.filterStateFavoriteKey] = false;
    } else {
      updatedFilters[AppStrings.filterStateFavoriteKey] = true;
    }

    emit(state.copyWith(selectedFilters: updatedFilters));
  }

  void _onToggleTypeFilter(
      ToggleTypeFilter event, Emitter<PokemonFilterState> emit) {
    final updatedFilters = Map<String, dynamic>.from(state.selectedFilters);

    updatedFilters[AppStrings.filterStateTypesKey] = event.types;

    emit(state.copyWith(selectedFilters: updatedFilters));
  }

  void _onRemoveFilter(RemoveFilter event, Emitter<PokemonFilterState> emit) {
    final updatedFilters = Map<String, dynamic>.from(state.selectedFilters);

    if (updatedFilters[event.filterKey] is bool) {
      updatedFilters[event.filterKey] = !state.selectedFilters[event.filterKey];
    } else if (updatedFilters[event.filterKey] is Set<String>) {
      final originalSet = updatedFilters[event.filterKey] as Set<String>;
      final updatedSet = Set<String>.from(originalSet)
        ..remove(event.valueToRemove);

      if (updatedSet.isEmpty) {
        updatedFilters.remove(event.filterKey); 
      } else {
        updatedFilters[event.filterKey] = updatedSet;
      }
    }

    emit(state.copyWith(selectedFilters: updatedFilters));
  }
}
