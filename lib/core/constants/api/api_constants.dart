class ApiConstants {
  static const String baseUrl = "https://pokeapi.co/api/v2";

  static const String pokemonList = "$baseUrl/pokemon";
  static String pokemonDetails(String id) => "$baseUrl/pokemon/$id";
  static String pokemonTypeList(String type) => "$baseUrl/type/$type";
}