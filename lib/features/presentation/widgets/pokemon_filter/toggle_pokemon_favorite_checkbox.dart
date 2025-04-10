import 'package:bloc_pagination/core/constants/app_strings.dart';
import 'package:flutter/material.dart';

class TogglePokemonFavoriteCheckbox extends StatefulWidget {
  const TogglePokemonFavoriteCheckbox({super.key});

  @override
  State<TogglePokemonFavoriteCheckbox> createState() =>
      _TogglePokemonFavoriteCheckboxState();
}

class _TogglePokemonFavoriteCheckboxState
    extends State<TogglePokemonFavoriteCheckbox> {
  bool favoriteIsChecked = false;
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
      value: favoriteIsChecked,
      onChanged: (bool? value) {
        setState(() {
          favoriteIsChecked = !favoriteIsChecked;
        });
      },
    );
  }
}
