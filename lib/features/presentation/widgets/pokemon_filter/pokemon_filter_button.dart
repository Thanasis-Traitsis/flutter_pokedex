import 'package:bloc_pagination/core/constants/app_decoration.dart';
import 'package:bloc_pagination/core/constants/app_values.dart';
import 'package:bloc_pagination/features/presentation/widgets/pokemon_filter/pokemon_filter_bottomsheet/pokemon_filter_bottomsheet.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PokemonFilterButton extends StatelessWidget {
  const PokemonFilterButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.primary,
      borderRadius: AppDecoration.filterButtonRadius,
      child: InkWell(
        onTap: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                top: AppDecoration.filterBottomSheetRadius,
              ),
            ),
            backgroundColor: Theme.of(context).colorScheme.surface,
            builder: (context) {
              return PokemonFilterBottomsheet();
            },
          );
        },
        borderRadius: AppDecoration.filterButtonRadius,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Theme.of(context).colorScheme.surface,
            ),
            borderRadius: AppDecoration.filterButtonRadius,
          ),
          width: AppValues.filterButtonSize,
          height: AppValues.filterButtonSize,
          alignment: Alignment.center,
          child: FaIcon(
            FontAwesomeIcons.sliders,
            size: AppValues.filterIconSize,
            color: Theme.of(context).colorScheme.surface,
          ),
        ),
      ),
    );
  }
}
