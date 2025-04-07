import 'dart:convert';

import 'package:bloc_pagination/core/constants/api/api_constants.dart';
import 'package:bloc_pagination/core/constants/app_strings.dart';
import 'package:bloc_pagination/features/data/models/pokemon_model.dart';
import 'package:bloc_pagination/features/data/models/pokemon_urls_list_model.dart';
import 'package:bloc_pagination/features/domain/entities/pokemon_entity.dart';
import 'package:bloc_pagination/features/domain/repositories/pokemon_repositories.dart';
import 'package:http/http.dart' as http;

class PokemonRepositoriesImpl implements PokemonRepositories {
  @override
  Future<List<String>> fetchPokemonUrls({required int limit,required int offset}) async {
    final PokemonUrlsListModel pokemonUrls;
    try {
       final Uri url = Uri.parse("${ApiConstants.pokemonList}?limit=$limit&offset=$offset");


      var response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        pokemonUrls = PokemonUrlsListModel.fromJson(data);

        return pokemonUrls.urlList;
      }

      return [];
    } catch (e) {
      throw Exception("${AppStrings.unableToLoadUrls}: $e");
    }
  }

  @override
  Future<PokemonEntity?> fetchPokemonDetails(String pokemonUrl) async {
    final PokemonEntity? pokemon;

    try {
      final Uri url = Uri.parse(pokemonUrl);

      var response = await http.get(url);


      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        pokemon = PokemonModel.fromJson(data);

        return pokemon;
      }

      return null;
    } catch (e) {
      throw Exception("${AppStrings.unableToLoadDetails}: $e");
    }
  }
}
