import 'package:bloc_pagination/core/constants/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:bloc_pagination/core/constants/app_spacing.dart';
import 'package:bloc_pagination/features/domain/entities/pokemon_entity.dart';
import 'package:bloc_pagination/features/presentation/pokemon_list_bloc/pokemon_list_bloc.dart';
import 'package:bloc_pagination/features/presentation/widgets/pokemon_card/pokemon_card.dart';

class PokemonListingSuccess extends StatefulWidget {
  final List<PokemonEntity> pokemons;

  const PokemonListingSuccess({
    super.key,
    required this.pokemons,
  });

  @override
  State<PokemonListingSuccess> createState() => _PokemonListingSuccessState();
}

class _PokemonListingSuccessState extends State<PokemonListingSuccess> {
  bool isFetchingMore = false;

  @override
  Widget build(BuildContext context) {
    return BlocListener<PokemonListBloc, PokemonListState>(
      listener: (context, state) {
        if (state is PokemonListSuccess) {
          isFetchingMore = false;
        }
      },
      child: widget.pokemons.isEmpty
          ? Center(
              child: Text(AppStrings.emptyFiltersPokemon),
            )
          : ListView.builder(
              cacheExtent: 350,
              itemCount: widget.pokemons.length,
              itemBuilder: (context, index) {
                if (index >= widget.pokemons.length - 100 &&
                    widget.pokemons.length > 100) {
                  if (!isFetchingMore) {
                    isFetchingMore = true;
                    context.read<PokemonListBloc>().add(FetchNextPage());
                  }
                }
                return Container(
                  margin: EdgeInsets.only(top: index != 0 ? AppSpacing.md : 0),
                  child: PokemonCard(
                    key: ValueKey(widget.pokemons[index].id),
                    pokemon: widget.pokemons[index],
                  ),
                );
              },
            ),
    );
  }
}
