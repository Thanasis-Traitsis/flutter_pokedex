import 'package:bloc_pagination/core/constants/app_strings.dart';
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
      title: Text(
        AppStrings.filterToggleFavoritesText,
        style: Theme.of(context).textTheme.bodyMedium,
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
