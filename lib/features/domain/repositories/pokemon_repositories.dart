import 'package:bloc_pagination/features/data/repositories/pokemon_repositories_impl.dart';
import 'package:bloc_pagination/features/domain/entities/pokemon_entity.dart';

abstract class PokemonRepositories {
  factory PokemonRepositories() => PokemonRepositoriesImpl();
  Future<List<String>> fetchPokemonUrls({required int limit,required int offset});
  Future<PokemonEntity?> fetchPokemonDetails(String pokemonUrl);
}