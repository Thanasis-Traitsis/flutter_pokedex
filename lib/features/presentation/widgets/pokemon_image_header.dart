import 'package:flutter/material.dart';

class PokemonImageHeader extends StatelessWidget {
  const PokemonImageHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Image(
      image: AssetImage("assets/images/pokemon.png"),
    );
  }
}
