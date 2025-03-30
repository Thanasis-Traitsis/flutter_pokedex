## Part 2 : Pagination & Infinite Scrolling

Welcome back, Flutter devs! In [Part 1](https://dev.to/thanasistraitsis/the-ultimate-guide-to-flutter-lists-with-bloc-part-1-2720), we explored how to build clean and efficient listings using Flutter and Bloc, powered by the **PokéAPI**. We successfully fetched data, displayed Pokémon cards, handled state with precision, and optimized our UI for performance.

Now, in Part 2, we’re stepping it up. 

We’re going to implement infinite scrolling and smart pagination. Think about the experience you get on top-tier apps. You know what I am talking about. The list just keeps going, with zero loading interruptions, and new content appears right as you need it. Well, that’s what we’re building.

We’ll cover:

- How to detect when to load more items
- How to fetch additional data behind the scenes
- How to prevent janky rebuilds or duplicate fetches
- And how to structure this cleanly inside Bloc

By the end, your Pokémon listing will feel instant, scalable, and app-store ready. Let’s dive in.

## What’s the Problem with Basic Pagination?

The classic approach to pagination usually goes something like this:

1. Wait until the user scrolls to the bottom
2. Show a loading spinner
3. Fetch the next batch of items
4. Append them to the list
5. Repeat

And technically… that works. But it’s not the kind of experience users expect anymore. Think about the apps you use every day. Instagram, TikTok, Ebay... You never see a loader. **You never wait**. You just scroll, and things appear as if they were already there.

That’s because these apps don't just paginate, they anticipate. And this is exactly what we are going to do as well.

### What We’re Building

In this part, we’re going to build a prefetching system. That means:

- You’ll load more items before the user hits the bottom
- You’ll fetch multiple pages ahead in the background
- You’ll make the scroll feel continuous and uninterrupted
- And most importantly, you’ll do it all cleanly with Bloc and efficient memory usage

This approach gives you the best of both worlds: great UX and great performance at the same time. Let's go!

## Pagination the right way

To implement pagination, we need a new Bloc event. Unlike the initial fetch, this event is triggered when we want to load more data, either while scrolling or during background prefetching.

```dart
class FetchNextPage extends PokemonListEvent {}
```

### How to track the progress of the list

Here's the thing:

When you add new items to your list and emit a state, Bloc (via Equatable) uses **props** to determine if the state has changed. If your list grows but the object reference stays the same, Bloc assumes nothing changed, and doesn’t rebuild the UI. So, many developers solve this by doing something like this:

```dart
emit(PokemonListSuccess(pokemons: List.of(pokemonList)));
```
Why this works? Because in our Bloc, we have set our props to look on the `pokemons` value. So, by implementing the `List.of` we create a new instance of the list. The Bloc sees a new instance, and as a result we get a new state with the updated list.

Does this work? Yes. Do we like it? **Of course not**. Let me explain you the reason.

With this approach, you're copying the entire list every time, even when just a few items are added. If you’ve got 1,000+ Pokémon already loaded, that’s an expensive operation for no real reason.

### The Better Way: Emit a Version Counter

Instead of copying the list, we introduce a simple int pagination value that only increases when the list changes:

```dart
final class PokemonListSuccess extends PokemonListState {
  final List<PokemonEntity> pokemons;
  final int pagination;

  const PokemonListSuccess({
    required this.pokemons,
    required this.pagination,
  });

  @override
  List<Object> get props => [pagination]; 
}
```

Now, whenever we fetch more data or toggle a favorite:
```dart
pagination++;
emit(PokemonListSuccess(pokemons: pokemonList, pagination: pagination));
```

By increasing the pagination, we trigger the **emit** every time we make a change in our list.
What this gives us:
- No need to copy lists (which saves memory and processing time)
- Bloc still detects a state change because pagination changes
- UI rebuilds as expected, even though the list reference stays the same

### Update Bloc and Events

Because the logic of the initial fetch is exactly the same with every fetch we will execute in any page, we will separate the `fetch pokemon` logic outside of the events. Good old *DRY* logic.

```dart
  Future<void> _fetchPokemons(Emitter<PokemonListState> emit,
      {int? chosenLimit}) async {
    try {
      final List<String> pokemonUrls = await PokemonRepositories()
          .fetchPokemonUrls(limit: chosenLimit ?? limit, offset: offset);

      if (pokemonUrls.isNotEmpty) {
        final List<PokemonEntity?> fetchedPokemons = await Future.wait(
            pokemonUrls
                .map((url) => PokemonRepositories().fetchPokemonDetails(url)));

        pokemonList.addAll(fetchedPokemons.whereType<PokemonEntity>());

        pagination++;
        offset += chosenLimit ?? limit;

        emit(PokemonListSuccess(pokemons: pokemonList, pagination: pagination));
      } else {
        emit(PokemonListError(message: "There are no more pokemons"));
      }
    } catch (e) {
      emit(PokemonListError(
          message: "Failed to fetch Pokémon: ${e.toString()}"));
    }
  }
```

Now, all you have to do, is call this function from the events we created, and keep track of the key variables:
- pagination (for triggering new state changes)
- offset (set the starting point of the next fetch, from the end of the last one)

```dart
...
  final List<PokemonEntity> pokemonList = [];
  int pagination = 0;
  int offset = 0;
  final int limit = 30;

  PokemonListBloc() : super(PokemonListInitial()) {
    on<InitialFetch>(_onInitialPokemonFetch);
    on<FetchNextPage>(_onFetchNextPage);
    on<ToggleFavoriteStatus>(_onToggleFavoriteStatus);
  }

  void _onInitialPokemonFetch(
      InitialFetch event, Emitter<PokemonListState> emit) async {
    emit(PokemonListLoading());
    await _fetchPokemons(emit, chosenLimit: event.firstPokemon);
  }

  void _onFetchNextPage(
      FetchNextPage event, Emitter<PokemonListState> emit) async {
    await _fetchPokemons(emit);
  }
  ...
```

### Pagination with an int
Here’s the magic line:

```dart
pagination++;
```
Instead of copying and re-emitting the whole list (which could already have hundreds of items), we simply bump a counter.

This triggers a new Bloc state, and thanks to:

```dart
@override
List<Object> get props => [pagination];
```
…the UI rebuilds as expected. Enough with the Bloc, I think it's time to take a look in the UI.

## UI implementation

Now that our Bloc handles everything, it’s time to connect the logic to the UI and turn this into a scrollable, preloading Pokédex that feels instant and endless. Let's break down the logic in small parts.

### Part 1: When should I fetch extra Pokémon?

When using `ListView.builder`, we gain access to something really useful: the **index** of each item as it’s being built. As we mentioned in Part 1, `ListView.builder` is highly memory-efficient, it doesn’t build the entire list at once, just what's visible on screen plus a few more. This gives us the perfect opportunity to detect when the user is getting close to the end of the list and dispatch an event to fetch more Pokémon. Here's a basic example:

```dart
...
child: ListView.builder(
        cacheExtent: 350,
        itemCount: widget.pokemons.length,
        itemBuilder: (context, index) {
          if (index >= 30) {
              context.read<PokemonListBloc>().add(FetchNextPage());
          }
...
```
>*Keep in mind, we initially fetch 50 Pokémon, that's why we start fetching the next page on Pokémon #30*

Now, when the user reaches at the pokemon #30, the `FetchNextPage()` will execute, and we will add 30 more Pokémon to the list. Amazing right? Something is missing though...

### Part 2: Avoid fetching the same page twice

The logic above works, but there’s one problem. If the `ListView.builder` keeps building items beyond index 30 (and it will), the condition `if (index >= 30)` will be true forever. That means we’ll keep dispatching the FetchNextPage event over and over, even if we already fetched it.

To solve this, we need to add a simple guard. A local boolean flag that prevents multiple fetches at once. Something like this:

```dart
bool isFetchingMore = false;

...

if (index >= widget.pokemons.length - 30 && !isFetchingMore) {
  isFetchingMore = true;
  context.read<PokemonListBloc>().add(FetchNextPage());
}
```
Then, once the new data comes in, we reset the flag to false using a BlocListener:

```dart
BlocListener<PokemonListBloc, PokemonListState>(
  listener: (context, state) {
    if (state is PokemonListSuccess) {
      isFetchingMore = false;
    }
  },
  child: ListView.builder(...)
)
```
Okat now let's take a step back and see what we have accomplished: 
- We fetch new Pokémon before the user reaches the bottom of the list
- We prevent duplicate fetches by tracking the loading state 

And now, to complete the perfect infinite scroll experience, we’re going to add one final enhancement. **Prefetching a few pages in advance during the initial load.**

### Part 3: Prefetch and Infinite Scrolling
The idea is simple: instead of fetching just one batch of Pokémon when the app starts, we fetch multiple pages ahead in the background. This way, we’re always staying 2–3 pages ahead of the user, so they never catch up to the data or hit a visible loading state.

It looks like this in the Bloc:
```dart
void _onInitialPokemonFetch(
  InitialFetch event,
  Emitter<PokemonListState> emit,
) async {
  emit(PokemonListLoading());

  await _fetchPokemons(emit, chosenLimit: event.firstPokemon); // First page
  await _fetchPokemons(emit); // Page 2
  await _fetchPokemons(emit); // Page 3
  await _fetchPokemons(emit); // Page 4
}
```

These additional fetches happen immediately after the first one, giving the user a smooth experience from the very first scroll gesture.

Now, when the user reaches index 200, the app already has Pokémon 201–300 ready to go. No delays. No spinners. Just scroll and enjoy.

Finally, apply these small adjustments to the UI, because we want to stay ahead of the user like we already said:

```dart
if (index >= widget.pokemons.length - 100 &&
              widget.pokemons.length > 100) {
            if (!isFetchingMore) {
              isFetchingMore = true;
              context.read<PokemonListBloc>().add(FetchNextPage());
            }
          }
```

The final screen should look like this:
```dart
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
      child: ListView.builder(
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
```

## Conclusion

That's it everybody! We have successfully delivered the best scrolling experience using Flutter + Bloc, completely from scratch. Not only did we manage to trigger pagination based on the list index, but we also **prefetched multiple pages upfront** to provide a truly seamless user experience.

[]()

This isn’t just a pagination strategy, it’s the foundation of how modern apps deliver seamless, high-performance data loading at scale.

Whether you're listing products, social feeds, restaurants, or Pokémon, this is a blueprint you can reuse again and again.

If you enjoyed this article and want to stay connected, feel free to connect with me on [LinkedIn](https://www.linkedin.com/in/thanasis-traitsis/).

If you'd like to dive deeper into the code and contribute to the project, visit the repository on [GitHub](https://github.com/Thanasis-Traitsis/flutter_pokedex/tree/part-1-listing).

Was this guide helpful? Consider buying me a coffee!☕️ Your contribution goes a long way in fuelling future content and projects. [Buy Me a Coffee](https://www.buymeacoffee.com/thanasis_traitsis).
