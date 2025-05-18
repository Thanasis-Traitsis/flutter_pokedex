import 'package:bloc_pagination/core/constants/app_spacing.dart';
import 'package:bloc_pagination/core/constants/app_strings.dart';
import 'package:bloc_pagination/features/domain/entities/pokemon_filter_entity.dart';
import 'package:bloc_pagination/features/presentation/widgets/pokemon_filter/pokemon_filter_selected_item.dart';
import 'package:flutter/material.dart';

class FilterChipsHelper {
  List<Widget> updateFilterChips({
    required PokemonFiltersEntity selectedFilters,
  }) {
    final List<Widget> filterChips = [];

    if (selectedFilters.showFavorites) {
      filterChips.add(
        Container(
          margin: EdgeInsets.only(
            left: filterChips.isEmpty ? AppSpacing.md : AppSpacing.xs,
          ),
          child: PokemonFilterSelectedItem(
            filterTitle: AppStrings.filterFavoriteTitle,
            filterType: PokemonFilterType.favorite,
          ),
        ),
      );
    }
    
    if (selectedFilters.types.isNotEmpty) {
      for (String type in selectedFilters.types) {
        filterChips.add(
          Container(
            margin: EdgeInsets.only(
              left: filterChips.isEmpty ? AppSpacing.md : AppSpacing.xs,
            ),
            child: PokemonFilterSelectedItem(
              filterTitle: type,
              filterType: PokemonFilterType.types,
            ),
          ),
        );
      }
    }

    return filterChips;
  }
}
