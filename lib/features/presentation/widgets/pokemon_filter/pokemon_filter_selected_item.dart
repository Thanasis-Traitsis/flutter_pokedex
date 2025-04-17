// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bloc_pagination/core/utils/extensions/text_capitalize.dart';
import 'package:bloc_pagination/features/presentation/pokemon_filter_bloc/pokemon_filter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:bloc_pagination/core/constants/app_decoration.dart';
import 'package:bloc_pagination/core/constants/app_spacing.dart';
import 'package:bloc_pagination/core/constants/app_values.dart';

class PokemonFilterSelectedItem extends StatelessWidget {
  final String filterKey;
  final String filterTitle;

  const PokemonFilterSelectedItem({
    super.key,
    required this.filterTitle,
    required this.filterKey,
  });

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
            filterTitle.capitalize(),
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(
            width: AppSpacing.xs,
          ),
          GestureDetector(
            onTap: () {
              context.read<PokemonFilterBloc>().add(RemoveFilter(
                    filterKey: filterKey,
                    valueToRemove: filterTitle,
                  ));
            },
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
