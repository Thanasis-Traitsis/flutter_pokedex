import 'package:bloc_pagination/config/theme/custom_text_type.dart';
import 'package:bloc_pagination/core/constants/app_strings.dart';
import 'package:bloc_pagination/core/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class TogglePokemonFavoriteCheckbox extends StatelessWidget {
  final bool isChecked;
  final ValueChanged<bool> onChanged;

  const TogglePokemonFavoriteCheckbox({
    super.key,
    required this.isChecked,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      checkColor: Theme.of(context).colorScheme.surface,
      contentPadding: EdgeInsets.zero,
      controlAffinity: ListTileControlAffinity.leading,
      title: CustomText(
        text: AppStrings.filterToggleFavoritesText,
        textType: CustomTextType.bodyMediumRegular,
      ),
      value: isChecked,
      onChanged: (value) {
        if (value != null) {
          onChanged(value);
        }
      },
    );
  }
}
