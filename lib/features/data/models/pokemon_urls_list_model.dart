class PokemonUrlsListModel {
  final List<String> urlList;

  PokemonUrlsListModel({required this.urlList});

  factory PokemonUrlsListModel.fromJson(Map<String, dynamic> json) {
    List<String> pokemonUrls = (json['results'] as List)
        .map((pokemon) => pokemon['url'].toString())
        .toList();

    return PokemonUrlsListModel(urlList: pokemonUrls);
  }
}
