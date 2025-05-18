import 'package:bloc_pagination/core/models/pokemon_type_model.dart';
import 'package:bloc_pagination/features/domain/entities/pokemon_entity.dart';

class PokemonModel extends PokemonEntity {
  PokemonModel({
    required super.id,
    required super.name,
    required super.types,
    required super.image,
    required super.isFavorite,
  });

  factory PokemonModel.fromJson(Map<String, dynamic> json, List<String> favoritePokemons) {
    final String id = json["id"].toString();
    
    return PokemonModel(
      id: id,
      name: json["name"],
      types: (json["types"] as List)
          .map((type) => pokemonTypeFromString(type["type"]["name"]))
          .toList(),
      image: json["sprites"]["front_default"],
      isFavorite: favoritePokemons.contains(id)
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