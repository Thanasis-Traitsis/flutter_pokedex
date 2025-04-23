import 'package:bloc_pagination/features/data/repositories/filters_repositories_impl.dart';
import 'package:bloc_pagination/features/domain/entities/pokemon_entity.dart';

abstract class FiltersRepositories {
  factory FiltersRepositories() => FiltersRepositoriesImpl();
}
