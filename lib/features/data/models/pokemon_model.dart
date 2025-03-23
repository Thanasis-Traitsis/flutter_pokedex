import 'package:bloc_pagination/config/theme/pokemon_type_model.dart';
import 'package:bloc_pagination/features/domain/entities/pokemon_entity.dart';

class PokemonModel extends PokemonEntity {
  PokemonModel({
    required super.id,
    required super.name,
    required super.types,
    required super.image,
    super.isFavorite = false,
  });

  factory PokemonModel.fromJson(Map<String, dynamic> json) {
    return PokemonModel(
      id: convertPokemonId(json["id"]),
      name: json["name"],
      types: (json["types"] as List)
          .map((type) => pokemonTypeFromString(type["type"]["name"]))
          .toList(),
      image: json["sprites"]["front_default"],
    );
  }

  @override
  String toString() {
    return "Pokemon: Name: $name, ID: $id, image: $image";
  }
}


PokemonType pokemonTypeFromString(String type) {
  return PokemonType.values.firstWhere(
    (e) => e.name == type,
    orElse: () => PokemonType.normal, 
  );
}

String convertPokemonId(int id) {
  return id.toString().padLeft(4, '0');
}