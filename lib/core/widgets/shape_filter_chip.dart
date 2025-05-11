import 'package:bloc_pagination/core/constants/app_strings.dart';
import 'package:bloc_pagination/features/presentation/widgets/pokemon_filter/pokemon_filter_selected_item.dart';
import 'package:flutter/material.dart';

Widget? ShapeFilterChip({required String key, required dynamic value}) {
  if (key == AppStrings.filterStateFavoriteKey) {
    return PokemonFilterSelectedItem(
      filterTitle: AppStrings.filterFavoriteTitle,
      filterKey: key,
    );
  } else if (key == AppStrings.filterStateTypesKey) {
    return PokemonFilterSelectedItem(
      filterTitle: value,
      filterKey: key,
    );
  }

  return null;
}