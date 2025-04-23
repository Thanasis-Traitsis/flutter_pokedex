import 'package:bloc_pagination/config/theme/app_theme.dart';
import 'package:bloc_pagination/config/theme/colors.dart';
import 'package:bloc_pagination/features/presentation/pokemon_filter_bloc/pokemon_filter_bloc.dart';
import 'package:bloc_pagination/features/presentation/pokemon_list_bloc/pokemon_list_bloc.dart';
import 'package:bloc_pagination/features/presentation/pokemons_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  CachedNetworkImage.logLevel = CacheManagerLogLevel.debug;

  final filtersBloc = PokemonFilterBloc();
  
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider<PokemonListBloc>(
        create: (context) =>
            PokemonListBloc(filtersBloc)..add(InitialFetch(20)),
      ),
      BlocProvider<PokemonFilterBloc>(
        create: (context) => filtersBloc,
      )
    ],
    child: const MainApp(),
  ));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme(AppColors.mainColors).getTheme(),
      home: PokemonsScreen(),
    );
  }
}
