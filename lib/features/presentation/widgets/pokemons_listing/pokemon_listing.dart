import 'package:bloc_pagination/features/presentation/pokemon_list_bloc/pokemon_list_bloc.dart';
import 'package:bloc_pagination/features/presentation/widgets/pokemons_listing/pokemon_listing_loading.dart';
import 'package:bloc_pagination/features/presentation/widgets/pokemons_listing/pokemon_listing_success.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PokemonListing extends StatelessWidget {
  const PokemonListing({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PokemonListBloc, PokemonListState>(
      builder: (context, state) {
        switch (state) {
          case PokemonListSuccess success:
            return PokemonListingSuccess(pokemons: success.getPokemons());
          case PokemonListError error:
            return Center(
              child: Text(error.message),
            );
          default:
            return PokemonListingLoading();
        }
      },
    );
  }
}
