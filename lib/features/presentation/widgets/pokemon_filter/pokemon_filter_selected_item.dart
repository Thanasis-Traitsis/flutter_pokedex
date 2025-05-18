import 'package:bloc_pagination/config/theme/colors.dart';
import 'package:bloc_pagination/config/theme/custom_text_type.dart';
import 'package:bloc_pagination/core/utils/extensions/pokemon_text.dart';
import 'package:bloc_pagination/core/widgets/custom_text.dart';
import 'package:bloc_pagination/features/domain/entities/pokemon_filter_entity.dart';
import 'package:bloc_pagination/features/presentation/pokemon_filter_bloc/pokemon_filter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:bloc_pagination/core/constants/app_decoration.dart';
import 'package:bloc_pagination/core/constants/app_spacing.dart';
import 'package:bloc_pagination/core/constants/app_values.dart';

class PokemonFilterSelectedItem extends StatelessWidget {
  final PokemonFilterType filterType;
  final String filterTitle;

  const PokemonFilterSelectedItem({
    super.key,
    required this.filterTitle,
    required this.filterType,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).extension<AppColors>()!;
    
    return InkWell(
      borderRadius: AppDecoration.filterSelectedItemRadius,
      onTap: () {
        context.read<PokemonFilterBloc>().add(RemoveFilter(
              filterKey: filterType,
              valueToRemove: filterTitle,
            ));
      },
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.typesCardPadding,
            vertical: AppSpacing.typesCardPadding / 3),
        decoration: BoxDecoration(
          borderRadius: AppDecoration.filterSelectedItemRadius,
          border: Border.all(
            width: AppDecoration.filterBorderWidth,
            color: appColors.darkGrayColor,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomText(
              text: filterTitle.capitalize(),
              textType: CustomTextType.bodyMediumRegular,
            ),
            const SizedBox(
              width: AppSpacing.xs,
            ),
            FaIcon(
              FontAwesomeIcons.xmark,
              size: AppValues.filterSelectedItemIconSize,
            ),
          ],
        ),
      ),
    );
  }
}
