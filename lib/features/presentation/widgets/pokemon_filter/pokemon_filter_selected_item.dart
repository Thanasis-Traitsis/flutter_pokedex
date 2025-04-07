import 'package:bloc_pagination/core/constants/app_decoration.dart';
import 'package:bloc_pagination/core/constants/app_spacing.dart';
import 'package:bloc_pagination/core/constants/app_values.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PokemonFilterSelectedItem extends StatelessWidget {
  const PokemonFilterSelectedItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.typesCardPadding,
          vertical: AppSpacing.typesCardPadding / 3),
      decoration: BoxDecoration(
        borderRadius: AppDecoration.filterSelectedItemRadius,
        border: Border.all(
          width: AppDecoration.filterBorderWidth,
          color: Theme.of(context).textTheme.bodyMedium!.color!,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Favourite",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(
            width: AppSpacing.xs,
          ),
          GestureDetector(
            onTap: () {},
            child: FaIcon(
              FontAwesomeIcons.xmark,
              size: AppValues.filterSelectedItemIconSize,
            ),
          )
        ],
      ),
    );
  }
}
