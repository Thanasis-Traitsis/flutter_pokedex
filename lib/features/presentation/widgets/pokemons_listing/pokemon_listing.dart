import 'package:bloc_pagination/core/constants/app_spacing.dart';
import 'package:bloc_pagination/features/presentation/pokemon_list_bloc/pokemon_list_bloc.dart';
import 'package:bloc_pagination/features/presentation/widgets/pokemon_card/pokemon_card.dart';
import 'package:bloc_pagination/features/presentation/widgets/pokemons_listing/pokemon_listing_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PokemonListing extends StatelessWidget {
  const PokemonListing({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PokemonListBloc, PokemonListState>(
      builder: (context, state) {
        if (state is PokemonListSuccess) {
          return ListView.builder(
            cacheExtent: 350,
            itemCount: state.pokemons.length,
            itemBuilder: (context, index) {
              return Container(
                margin: EdgeInsets.only(top: index != 0 ? AppSpacing.md : 0),
                child: PokemonCard(
                  key: ValueKey(state.pokemons[index].id),
                  pokemon: state.pokemons[index],
                ),
              );
            },
          );
        } else if (state is PokemonListError) {
          return Center(
            child: Text(state.message),
          );
        } else {
          return PokemonListingLoading();
        }
      },
    );
  }
}
