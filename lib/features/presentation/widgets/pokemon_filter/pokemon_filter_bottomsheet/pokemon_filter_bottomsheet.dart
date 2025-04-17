import 'package:bloc_pagination/core/constants/app_strings.dart';
import 'package:bloc_pagination/features/presentation/pokemon_filter_bloc/pokemon_filter_bloc.dart';
import 'package:bloc_pagination/features/presentation/pokemon_filter_bloc/pokemon_filter_controller.dart';
import 'package:bloc_pagination/features/presentation/widgets/pokemon_filter/pokemon_filter_bottomsheet/pokemon_filter_bottomsheet_category.dart';
import 'package:bloc_pagination/features/presentation/widgets/pokemon_filter/pokemon_filter_bottomsheet/pokemon_filter_bottomsheet_container.dart';
import 'package:bloc_pagination/features/presentation/widgets/pokemon_filter/pokemon_filter_bottomsheet/toggle_pokemon_favorite_checkbox.dart';
import 'package:bloc_pagination/features/presentation/widgets/pokemon_filter/pokemon_filter_bottomsheet/toggle_pokemon_types_filter_cards.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PokemonFilterBottomsheet extends StatefulWidget {
  const PokemonFilterBottomsheet({super.key});

  @override
  State<PokemonFilterBottomsheet> createState() =>
      _PokemonFilterBottomsheetState();
}

class _PokemonFilterBottomsheetState extends State<PokemonFilterBottomsheet> {
  late PokemonFilterController controller;

  @override
  void initState() {
    super.initState();
    final currentState = context.read<PokemonFilterBloc>().state;
    controller = PokemonFilterController(currentState);
  }

  @override
  Widget build(BuildContext context) {
    return PokemonFilterBottomsheetContainer(
      pokemonFilterCategories: [
        PokemonFilterBottomsheetCategory(
          title: AppStrings.filterFavoriteTitle,
          filterCategory: TogglePokemonFavoriteCheckbox(
            isChecked: controller.showOnlyFavorites,
            onChanged: (value) {
              setState(() {
                controller.showOnlyFavorites = value;
              });
            },
          ),
          spacingBetween: false,
        ),
        PokemonFilterBottomsheetCategory(
          title: AppStrings.filterTypesTitle,
          filterCategory: TogglePokemonTypesFilterCards(
            selectedTypes: controller.selectedPokemonTypes,
            onChanged: (updated) {
              setState(() {
                controller.selectedPokemonTypes = updated;
              });
            },
          ),
        ),
      ],
      applyButtonOnPressed: () {
        controller.applyFilters(context);
        Navigator.pop(context);
      },
    );
  }
}
