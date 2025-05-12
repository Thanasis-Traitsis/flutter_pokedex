import 'package:bloc_pagination/config/theme/colors.dart';
import 'package:bloc_pagination/config/theme/custom_text_type.dart';
import 'package:bloc_pagination/core/constants/app_decoration.dart';
import 'package:bloc_pagination/core/constants/app_spacing.dart';
import 'package:bloc_pagination/core/constants/app_strings.dart';
import 'package:bloc_pagination/core/constants/app_values.dart';
import 'package:bloc_pagination/core/widgets/custom_text.dart';
import 'package:bloc_pagination/features/presentation/pokemon_filter_bloc/pokemon_filter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PokemonFilterDeleteButton extends StatelessWidget {
  const PokemonFilterDeleteButton({super.key});

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).extension<AppColors>()!;

    return Padding(
      padding: const EdgeInsets.only(left: AppSpacing.xs),
      child: Material(
        color: appColors.darkGrayColor,
        borderRadius: AppDecoration.filterSelectedItemRadius,
        child: InkWell(
          borderRadius: AppDecoration.filterSelectedItemRadius,
          onTap: () {
            context.read<PokemonFilterBloc>().add(RemoveAllFilters());
          },
          child: Container(
            padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.typesCardPadding,
                vertical: AppSpacing.typesCardPadding / 3),
            decoration: BoxDecoration(
              borderRadius: AppDecoration.filterSelectedItemRadius,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomText(
                 text: AppStrings.deleteFiltersText,
                 textType: CustomTextType.bodyMediumRegular,
                 isWhite: true,
                ),
                const SizedBox(
                  width: AppSpacing.xs,
                ),
                FaIcon(
                  FontAwesomeIcons.trashCan,
                  size: AppValues.filterSelectedItemIconSize,
                  color: appColors.whiteColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
