class PokemonUrlsListModel {
  final List<String> urlList;

  PokemonUrlsListModel({required this.urlList});

  factory PokemonUrlsListModel.fromJson(Map<String, dynamic> json,
      {bool searchForTypes = false}) {
    List<String> pokemonUrls = searchForTypes
        ? (json['pokemon'] as List)
            .map((pokemon) => pokemon['pokemon']['url'].toString())
            .toList()
        : (json['results'] as List)
            .map((pokemon) => pokemon['url'].toString())
            .toList();

    return PokemonUrlsListModel(urlList: pokemonUrls);
  }
}
