import 'package:bloc_pagination/core/models/pokemon_type_model.dart';

class PokemonEntity {
  final String id;
  final String name;
  final List<PokemonType> types;
  final String? image;
  final bool isFavorite;

  const PokemonEntity({
    required this.id,
    required this.name,
    required this.types,
    required this.image,
    required this.isFavorite,
  });

  PokemonEntity copyWith({bool? isFavorite}) {
    return PokemonEntity(
      id: id,
      name: name,
      types: types,
      image: image,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
