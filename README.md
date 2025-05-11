## Part 3 : Powerful Filtering for Your Flutter Listings

Welcome back to our Flutter listing series! In Parts 1 and 2, we built a powerful Pokémon listing with pagination and infinite scrolling. Now it's time to introduce another essential feature of any good listing: **filtering**.

Effective filtering transforms a simple list into a powerful tool that helps users find exactly what they're looking for, without extra effort and with less time needed. Whether you're filtering Pokémon by type, searching products by category, or sorting messages by date, the principles remain the same.

In this third blog, we'll implement a complete filtering system for our Pokédex app. We'll create a simple **FilterBloc** that communicates seamlessly with our **ListingBloc**, apply filters efficiently without sacrificing performance, and ensure a smooth UX throughout the process.

Let's explore how to build a filtering system that's both powerful and maintainable, all while keeping our Pokémon list running smoothly.

## Let's talk about the Filters

The filtering system of a listing is a complex feature. It needs to combine multiple filter criteria while ensuring the UI responds appropriately throughout the application. This complexity requires the filter to maintain its own state. And that's where our beloved friend **Bloc** comes to the rescue.

### Creating the Filters State

First, we need to consider that we don't need multiple filter states. The `PokemonFilterState` is singular, and only its values change as users select different filtering options. We can start with a simple implementation:

```dart
final class PokemonFilterState extends Equatable {
  final Map<String, dynamic> selectedFilters;

  const PokemonFilterState({this.selectedFilters = const {}});

  PokemonFilterState copyWith({Map<String, dynamic>? selectedFilters}) {
    return PokemonFilterState(
      selectedFilters: selectedFilters ?? this.selectedFilters,
    );
  }

  @override
  List<Object> get props => [selectedFilters];
}
```

I chose `Map<String, dynamic>` for the selected filters because it gives us flexibility to store different types of filter values. For example, we might need to store string values for Pokemon types, numeric ranges for stats, or boolean values for availability filters—all within the same state object.

What makes this approach powerful is that I can track every filter change reliably by using consistent `key` values as identifiers. By centralizing these `keys`—either fetching them from an API or storing them as static constants—I ensure my UI and business logic remain perfectly aligned. This prevents filter-related bugs and makes the codebase more maintainable as the filtering system grows in complexity.

### Apply filter changes with Events

Moving on, now that we initialized our state with an empty value, we need to figure out a way to add some values. That's where the events step up. But, what are the actual events that we need? Let's figure out first how to add a value. For this example, we will cover only two types of filters with the first one being the favorite pokemons, and the second one is based on the type of each pokemon. Let's make it!

#### Toggling the filters

```dart
sealed class PokemonFilterEvent extends Equatable {
  const PokemonFilterEvent();

  @override
  List<Object> get props => [];
}

class ToggleFilter extends PokemonFilterEvent {
  final bool? showFavorites;
  final Set<String>? types;

  const ToggleFilter({this.showFavorites, this.types});
}
```

With this approach, we separate the logic of each filter by providing its own dedicated variable. This gives us clearer code and more flexibility when handling different filter types:

1. For favorite Pokémon, we simply need a boolean flag `(showFavorites)` - either we want to see favorites only **(true)** or we don't **(false)**. Nothing more complex is required here.
2. For Pokémon types, we use a `Set<String>` instead of a List. Why? Because each type should only appear once in our filter criteria (there's no scenario where we'd need to apply "Water" type twice). Sets inherently prevent duplicates and offer performance benefits when checking if a value exists.

💡Always use the right tools for the job. Sets aren't just about preventing duplicates - they also provide powerful operations like union (combining filters), intersection (finding common elements), and difference (removing specific filters) that make complex filter manipulations much cleaner. When your app grows and users demand more sophisticated filtering capabilities, you'll thank yourself for this decision.💡

Now, our event is ready to receive filter changes. Notice how we made both parameters nullable? This allows us to toggle just one filter at a time without affecting the others. For instance, a user might want to change only the type filter without modifying their favorites preference.

#### Remove the filters

Adding filters is only half the job. Users also need an easy way to remove them. Thanks to the well-structured foundation we’ve built, implementing filter removal is pretty straightforward.

To remove a specific filter value, we simply need two pieces of information:
- The `key` of the filter (e.g. "type")
- The `value` we want to remove (e.g. "Fire")

This is important because some filters, like Pokémon types, can support multiple values at once. Here's how we model these events:

```dart
class RemoveFilter extends PokemonFilterEvent {
  final String filterKey;
  final String valueToRemove;

  const RemoveFilter({required this.filterKey, required this.valueToRemove});
}

class RemoveAllFilters extends PokemonFilterEvent {}
```
With this structure, removing a single filter or clearing all filters becomes a clean, manageable task, one that fits perfectly into our event-driven system.

### Combine everything into Bloc

Now comes the fun part! We've built a clean event structure and designed a state to hold our filter data. It's time to glue everything together into a working Bloc.

#### Bloc Constructor
To begin, let's initialize our Bloc with a proper constructor. We'll register each event type with its corresponding handler method, creating a clear mapping between user actions and our business logic:
```dart
  PokemonFilterBloc() : super(const PokemonFilterState()) {
    on<ToggleFilter>(_onToggleFilter);
    on<RemoveFilter>(_onRemoveFilter);
    on<RemoveAllFilters>(_onRemoveAllFilters);
  }
```
This constructor initializes our Bloc with an empty PokemonFilterState and registers three event handlers that we'll implement next.

#### Toggle filter

```dart
void _onToggleFilter(ToggleFilter event, Emitter<PokemonFilterState> emit) {
  final updatedFilters = Map<String, dynamic>.from(state.selectedFilters);

  if (event.showFavorites != null) {
    final currentValue =
        state.selectedFilters[AppStrings.filterStateFavoriteKey];

    if (currentValue == true) {
      updatedFilters.remove(AppStrings.filterStateFavoriteKey);
    } else {
      updatedFilters[AppStrings.filterStateFavoriteKey] = true;
    }
  }

  if (event.types != null) {
    updatedFilters[AppStrings.filterStateTypesKey] = event.types;
  }

  emit(state.copyWith(selectedFilters: updatedFilters));
}
```

This implementation does several important things:

1. It creates a mutable copy of our current filters map to work with
2. For **favorites**, it toggles the value - removing it if already true, or setting it to true if not present
3. For **Pokémon types**, it simply updates the map with the new set of types
4. Finally, it emits a new state with the updated filters

Notice how we're using string constants from AppStrings as keys. This centralization ensures consistency between our Bloc implementation and UI code, making maintenance much easier.

#### Removing filters (1-by-1 or all of them)

Of course, we need to give users the ability to remove filters they've applied. Our implementation handles two scenarios: removing individual filter values and clearing all filters at once.

*Don't miss out on the comments inside the code. It will give you a clear view on how everything works.*
```dart
void _onRemoveFilter(RemoveFilter event, Emitter<PokemonFilterState> emit) {
  final updatedFilters = Map<String, dynamic>.from(state.selectedFilters);

  if (updatedFilters[event.filterKey] is bool) {
    // For boolean filters (like favorites), simply remove the entire key
    updatedFilters.remove(event.filterKey);
  } else if (updatedFilters[event.filterKey] is Set<String>) {
    // For set-based filters (like types), remove just the specific value
    final originalSet = updatedFilters[event.filterKey];
    final updatedSet = Set<String>.from(originalSet)
      ..remove(event.valueToRemove);

    // If removing this value leaves the set empty, remove the entire filter key
    if (updatedSet.isEmpty) {
      updatedFilters.remove(event.filterKey);
    } else {
      updatedFilters[event.filterKey] = updatedSet;
    }
  }

  emit(state.copyWith(selectedFilters: updatedFilters));
}

void _onRemoveAllFilters(
    RemoveAllFilters event, Emitter<PokemonFilterState> emit) {
  emit(state.copyWith(selectedFilters: {}));
}
```
This implementation demonstrates the flexibility of our `Map<String, dynamic>` approach. The `_onRemoveFilter` method handles different filter types:
1. Boolean filters (such as favorites) are handled with a simple `key` removal, just toggle it off and it's gone
2. For collection-based filters like Pokémon types, we surgically remove just the selected value while preserving others
3. We maintain clean state by automatically removing empty collections. **There is no need to track filters that don't filter anything**

The companion `_onRemoveAllFilters` method offers a "reset button" functionality by replacing the entire filters map with an empty one, effectively returning to a fresh start.

## Communication between Blocs

Now that we have our Filters bloc ready to go, we need to make something out of it. In order to see the filters work, we need to apply them to our current Pokémon list. But wait, our list is in our Pokémon List Bloc, so how do we combine these two Blocs?

A simple solution that comes to mind right away is utilizing BlocListener and handling everything in our UI. But let's be honest, do we really want to complicate our UI with this business logic? I don't think so. So, let me show you a more elegant approach!

```dart
final PokemonFilterBloc filterBloc;
late final StreamSubscription filterSubscription;

final Map<String, PokemonEntity> pokemonMap = {};
Map<String, PokemonEntity> filteredMap = {};

bool showOnlyFavorites = false;
Set<String> selectedTypes = {};
bool isFiltering = false;

  PokemonListBloc(this.filterBloc) : super(PokemonListInitial()) {
    
    filterSubscription = filterBloc.stream.listen((filterState) {
      showOnlyFavorites =
          filterState.selectedFilters[AppStrings.filterStateFavoriteKey] ??
              false;
      selectedTypes =
          filterState.selectedFilters[AppStrings.filterStateTypesKey] ?? {};

      if (showOnlyFavorites || selectedTypes.isNotEmpty) {
        isFiltering = true;
        if (filteredMap.isEmpty) {
          filteredMap = Map.from(pokemonMap);
        }
      } else {
        isFiltering = false;
      }

      add(ApplyFilters());
    });

    on<InitialFetch>(_onInitialPokemonFetch);
    on<FetchNextPage>(_onFetchNextPage);
    on<ToggleFavoriteStatus>(_onToggleFavoriteStatus);
    on<ApplyFilters>(_onApplyFilters);
  }
```

What's happening here? Instead of having our UI act as the intermediary between blocs (bad practise), we're directly injecting our `filterBloc` into our `PokemonListBloc`. This creates a clean dependency that follows the natural flow of our application logic: filters affect the list, not the other way around.

The real magic happens with `filterSubscription`. We're creating a **stream subscription** that listens to any changes in the filter state. Basically, the stream is a spy that works for our List Bloc. His secret mission is to hear everything that happens in the Filter Bloc headquarters and immediately report back. Whenever our spy detects a change in filter operations, it secretly dispatches an `ApplyFilters` event to its commander (the List Bloc), all without the UI ever knowing about this covert operation. How we actually act on it:

1. Extract the current filter values (favorites and types)
2. Search if any filtering is currently active
3. Prepare our data structure for filtered results if needed
4. Dispatch an internal ApplyFilters event to the list bloc itself

This approach keeps our UI clean and simple while maintaining proper separation of concerns. The List Bloc is responsible for maintaining and filtering the list, and it simply consumes the filter criteria from the filter bloc. 

⚠️ Don’t forget to close your ears when you’re done listening!
Since we subscribed to another bloc’s stream, it’s critical to cancel that subscription in close(). Otherwise, it leads to memory leaks. Always clean up after your listeners to keep your app healthy and efficient!
```dart
  @override
  Future<void> close() {
    filterSubscription.cancel();
    return super.close();
  }
```

Okay now that we took care of everything, let's take a closer look on the List Bloc and how it actually handles the filters.

## New List Bloc with Two Lists

Now that our filter data is flowing smoothly between blocs, we need to address one final architectural challenge: managing our filtered and unfiltered data efficiently.

To maintain proper separation of concerns, our listing implementation uses two variables:

- `pokemonMap`: Our source of truth that contains the complete, unfiltered collection of Pokémon
- `filteredMap`: A derived view that contains only the Pokémon matching our current filter criteria

This dual-map approach gives us significant performance advantages. We can apply complex filtering operations without repeatedly processing the entire dataset, and we maintain quick access to our original data when filters are cleared.

### Apply Filters Event

There is one main event that handles filter changes — the `ApplyFilters` event. Remember inside our `StreamSubscription` when we secretly called:
```dart
add(ApplyFilters());
```

Here is what's going on inside this event:

```dart
  void _onApplyFilters(
      ApplyFilters event, Emitter<PokemonListState> emit) async {
    emit(PokemonListLoading());

    try {
      if (showOnlyFavorites) {
        await _loadUnloadedFavoritePokemons();
      } else if (selectedTypes.isNotEmpty) {
        await _loadPokemonsBySelectedTypes();
      }

      _emitSuccessState(
        emit,
        currentMap: isFiltering ? filteredMap : pokemonMap,
      );
    } catch (e) {
      emit(
          PokemonListError(message: "${AppStrings.failedToLoad}: ${e.toString()}"));
    }
  }

  // This is what's going on inside the emit success state:
    void _emitSuccessState(Emitter<PokemonListState> emit,
      {Map<String, PokemonEntity>? currentMap}) {
    emit(PokemonListSuccess(
      pokemonMap: currentMap ?? pokemonMap,
      pagination: pagination,
      favoritePokemons: favoriteIds.length,
      showOnlyFavorites: showOnlyFavorites,
      selectedTypes: selectedTypes,
    ));
  }
```

What makes this special is that we don’t rebuild or mutate the original `pokemonMap`. Instead, if filters are active, we work with a separate `filteredMap`, leaving the full dataset intact.

And here’s the big twist: even inside the event, we don’t slice and filter data manually. We simply check if the data we need already exists. If not? **We fetch only what’s missing**.

No waste. No duplication. No rebuild.

But where is the real filtering logic? Thought you'd never ask! It’s all deferred to the `PokemonListSuccess` state. That’s where we dynamically compute what to show, based on the user's filters and our clean maps.

Ready for the big reveal? I present you... **THE NEW STATE**:
```dart
final class PokemonListSuccess extends PokemonListState {
  final Map<String, PokemonEntity> pokemonMap;
  final int pagination;
  final int favoritePokemons;
  final bool showOnlyFavorites;
  final Set<String> selectedTypes;

  const PokemonListSuccess({
    required this.pokemonMap,
    this.pagination = 0,
    this.favoritePokemons = 0,
    this.showOnlyFavorites = false,
    this.selectedTypes = const {},
  });

  List<PokemonEntity> getPokemons() {
    return PokemonDisplayHelper.getDisplayedPokemons(
      pokemon: pokemonMap,
      showOnlyFavorites: showOnlyFavorites,
      selectedTypes: selectedTypes,
    );
  }

  @override
  List<Object> get props => [
        pokemonMap,
        pagination,
        favoritePokemons,
        showOnlyFavorites,
        selectedTypes
      ];
}
```
Instead of keeping filtered results in the state itself, we are making the state compute them on demand through the `getPokemons()` method. Why? Because this approach has several powerful advantages. For example, our widgets (UI) only need to call `getPokemons(`) without knowing about the filtering complexity behind the scenes. Plus, the state is pretty clean because we exclude the complex part into a helper.

### Enter the Helper

The real workhorse behind our filtering system is the `PokemonDisplayHelper` class:

```dart
class PokemonDisplayHelper {
  static List<PokemonEntity> getDisplayedPokemons({
    required Map<String, PokemonEntity> pokemon,
    required bool showOnlyFavorites,
    required Set<String> selectedTypes,
    SortOption sortBy = SortOption.id,
  }) {
    List<PokemonEntity> filtered = pokemon.values.where((pokemon) {
      final matchesFavorite = !showOnlyFavorites || pokemon.isFavorite;
      final matchesType = selectedTypes.isEmpty ||
          pokemon.types.any((type) => selectedTypes.contains(type.name));

      return matchesFavorite && matchesType;
    }).toList();

    _sortPokemon(filtered, sortBy);

    return filtered;
  }

  static void _sortPokemon(List<PokemonEntity> list, SortOption sortBy) {
    switch (sortBy) {
      case SortOption.id:
        list.sort((pokemonA, pokemonB) =>
            int.parse(pokemonA.id).compareTo(int.parse(pokemonB.id)));
        break;
      case SortOption.name:
        list.sort(
            (pokemonA, pokemonB) => pokemonA.name.compareTo(pokemonB.name));
        break;
      case SortOption.type:
        list.sort((pokemonA, pokemonB) =>
            pokemonA.types.first.name.compareTo(pokemonB.types.first.name));
        break;
    }
  }
}
```
Let's break down what's happening in our filtering method:

1. We start with values from our `Map<String, PokemonEntity>` since we need to work with the actual objects
2. We filter using Dart's `where()` method, applying our filtering rules:
    - A Pokémon passes the favorite filter if either `showOnlyFavorites` is false OR the Pokémon is marked as favorite
    - A Pokémon passes the type filter if either no types are selected OR it has at least one matching type
3. We combine these conditions with a logical AND `(&&)`, so a Pokémon must satisfy both filters to be included
4. Finally, we apply sorting to the filtered list based on the requested sort option

### The UI: Stupidly Simple

```dart
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
```

That's it. No, seriously, that's the entire listing component! Just a simple `BlocBuilder` that renders different widgets based on the state.

## Conclusion

There is no need to dive deeper into the UI implementation. You now have all the business logic ready and you can use it however you want in your own projects. You're free to go and make the best out of these solid fundamentals we've created for filtering. If you want to see my complete approach including the UI components and styles, you can always check out the GitHub repository linked at the bottom of this blog.

If you enjoyed this article and want to stay connected, feel free to connect with me on [LinkedIn](https://www.linkedin.com/in/thanasis-traitsis/).

If you'd like to dive deeper into the code and contribute to the project, visit the repository on [GitHub](https://github.com/Thanasis-Traitsis/flutter_pokedex/tree/part-3-filters).

Was this guide helpful? Consider buying me a coffee!☕️ Your contribution goes a long way in fuelling future content and projects. [Buy Me a Coffee](https://www.buymeacoffee.com/thanasis_traitsis).
