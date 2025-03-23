import 'package:flutter/material.dart';

enum PokemonType {
  normal,
  fire,
  water,
  grass,
  electric,
  ice,
  fighting,
  poison,
  ground,
  flying,
  psychic,
  bug,
  rock,
  ghost,
  dark,
  dragon,
  steel,
  fairy,
}

extension PokemonTypeExtension on PokemonType {
  Color get color {
    switch (this) {
      case PokemonType.normal:
        return Colors.grey.shade400;
      case PokemonType.fire:
        return Colors.red.shade600;
      case PokemonType.water:
        return Colors.blue.shade600;
      case PokemonType.grass:
        return Colors.green.shade600;
      case PokemonType.electric:
        return Colors.yellow.shade600;
      case PokemonType.ice:
        return Colors.cyan.shade300;
      case PokemonType.fighting:
        return Colors.brown.shade600;
      case PokemonType.poison:
        return Colors.purple.shade600;
      case PokemonType.ground:
        return Colors.orange.shade600;
      case PokemonType.flying:
        return Colors.blue.shade300;
      case PokemonType.psychic:
        return Colors.pink.shade400;
      case PokemonType.bug:
        return Colors.lightGreen.shade600;
      case PokemonType.rock:
        return Colors.grey.shade600;
      case PokemonType.ghost:
        return Colors.deepPurple.shade600;
      case PokemonType.dark:
        return Colors.black54;
      case PokemonType.dragon:
        return Colors.indigo.shade600;
      case PokemonType.steel:
        return Colors.blueGrey.shade400;
      case PokemonType.fairy:
        return Colors.pink.shade300;
      }
  }

String get name {
  switch (this) {
    case PokemonType.normal:
      return "normal";
    case PokemonType.fire:
      return "fire";
    case PokemonType.water:
      return "water";
    case PokemonType.grass:
      return "grass";
    case PokemonType.electric:
      return "electric";
    case PokemonType.ice:
      return "ice";
    case PokemonType.fighting:
      return "fighting";
    case PokemonType.poison:
      return "poison";
    case PokemonType.ground:
      return "ground";
    case PokemonType.flying:
      return "flying";
    case PokemonType.psychic:
      return "psychic";
    case PokemonType.bug:
      return "bug";
    case PokemonType.rock:
      return "rock";
    case PokemonType.ghost:
      return "ghost";
    case PokemonType.dark:
      return "dark";
    case PokemonType.dragon:
      return "dragon";
    case PokemonType.steel:
      return "steel";
    case PokemonType.fairy:
      return "fairy";
  }
}
}
