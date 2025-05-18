import 'package:bloc_pagination/config/theme/custom_text_type.dart';
import 'package:bloc_pagination/core/constants/app_strings.dart';
import 'package:bloc_pagination/core/widgets/custom_text.dart';
import 'package:bloc_pagination/features/domain/entities/pokemon_filter_entity.dart';
import 'package:bloc_pagination/features/presentation/pokemon_filter_bloc/pokemon_filter_bloc.dart';
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
  final ScrollController _scrollController = ScrollController();
  PokemonFiltersEntity? _previousFilters;
  bool isFetchingMore = false;

  @override
  void initState() {
    _previousFilters = context.read<PokemonFilterBloc>().state.selectedFilters;
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PokemonListBloc, PokemonListState>(
      listener: (context, state) {
        if (state is PokemonListSuccess) {   
          isFetchingMore = false;

          if(_previousFilters != null && _previousFilters!.isNotEmpty) {
            _scrollController.jumpTo(0);
          }

          _previousFilters = state.filterState.selectedFilters;
        }
      },
      child: widget.pokemons.isEmpty
          ? Center(
              child: CustomText(
                text: AppStrings.emptyFiltersPokemon,
                textType: CustomTextType.bodyMediumRegular,
              ),
            )
          : ListView.builder(
              controller: _scrollController,
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
