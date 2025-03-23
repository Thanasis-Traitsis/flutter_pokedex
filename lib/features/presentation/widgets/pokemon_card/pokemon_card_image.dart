import 'package:bloc_pagination/core/constants/app_values.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

Widget PokemonCardImage(String pokeUrl) {
  return SizedBox(
    width: AppValues.pokemonImageSize,
    child: CachedNetworkImage(
      imageUrl: pokeUrl,
      placeholder: (context, url) => Center(child: CircularProgressIndicator()),
      errorWidget: (context, url, error) => Icon(Icons.error),
    ),
  );
}
