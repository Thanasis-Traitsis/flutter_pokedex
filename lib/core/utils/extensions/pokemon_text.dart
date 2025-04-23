extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }

  String convertPokemonId() {
    return "# ${padLeft(5, '0')}";
  }

  String formatPokemonName() {
    if (!contains('-')) {
      return capitalize();
    }

    final parts = split('-');
    final baseName = parts.first.capitalize();
    final form = parts.sublist(1).join(' ')._capitalizeEachWord();

    return '$baseName $form';
  }

  String _capitalizeEachWord() {
    return split(' ').map((word) => word.capitalize()).join(' ');
  }
}
