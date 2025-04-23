import 'package:bloc/bloc.dart';
import 'package:bloc_pagination/core/constants/app_strings.dart';
import 'package:equatable/equatable.dart';

part 'pokemon_filter_event.dart';
part 'pokemon_filter_state.dart';

class PokemonFilterBloc extends Bloc<PokemonFilterEvent, PokemonFilterState> {
  PokemonFilterBloc() : super(const PokemonFilterState()) {
    on<ToggleFilter>(_onToggleFilter);
    on<RemoveFilter>(_onRemoveFilter);
    on<RemoveAllFilters>(_onRemoveAllFilters);
  }

  void _onToggleFilter(ToggleFilter event, Emitter<PokemonFilterState> emit) {
    final updatedFilters = Map<String, dynamic>.from(state.selectedFilters);

    if (event.showFavorites != null) {
      final currentValue =
          state.selectedFilters[AppStrings.filterStateFavoriteKey];

      if (currentValue == true) {
        updatedFilters.remove(AppStrings.filterStateFavoriteKey);
      } else {
        updatedFilters[AppStrings.filterStateFavoriteKey] = true;
      }
    }

    if (event.types != null) {
      updatedFilters[AppStrings.filterStateTypesKey] = event.types;
    }

    emit(state.copyWith(selectedFilters: updatedFilters));
  }

  void _onRemoveFilter(RemoveFilter event, Emitter<PokemonFilterState> emit) {
    final updatedFilters = Map<String, dynamic>.from(state.selectedFilters);

    if (updatedFilters[event.filterKey] is bool) {
      updatedFilters.remove(event.filterKey);
    } else if (updatedFilters[event.filterKey] is Set<String>) {
      final originalSet = updatedFilters[event.filterKey];
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

  void _onRemoveAllFilters(
      RemoveAllFilters event, Emitter<PokemonFilterState> emit) {
    emit(state.copyWith(selectedFilters: {}));
  }
}
