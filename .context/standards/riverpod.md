# Riverpod Standards

## Provider Types

| Use case | Provider type |
|----------|--------------|
| Reactive DB query | `StreamProvider.autoDispose` |
| One-shot async load | `FutureProvider.autoDispose` |
| Singleton service | `Provider` (no autoDispose) |
| Mutable UI state | `NotifierProvider` |
| Parameterized query | `.family` modifier |

## Naming Conventions

- Providers: `<noun><Noun>Provider` — e.g., `allTunesProvider`, `singleTuneProvider`
- Notifiers: `<Noun>Notifier` — e.g., `TuneFiltersNotifier`
- Use descriptive names that indicate what data is provided, not implementation details.

## Architecture Rules

- `databaseProvider` is the single source of truth for the `AppDatabase` instance.
- All other data providers depend on `databaseProvider` via `ref.watch(databaseProvider)`.
- Providers never import widget code. Widgets import providers, not the other way around.
- Use `ref.watch()` in build methods, `ref.read()` in callbacks and event handlers.

## Testing Providers

- Create a `ProviderContainer` with `databaseProvider` overridden to an in-memory DB.
- Use `container.listen()` to capture emissions.
- Always dispose the container in `tearDown`.
- Allow a small `Future.delayed` for stream debounce when testing reactive providers.

## Notifiers

- `Notifier` (synchronous) for UI filter/sort state.
- `AsyncNotifier` for state that requires async initialization.
- Keep mutation methods focused — one action per method.
- Use `copyWith` patterns for immutable state updates (see `TuneFilters`).

## Avoid

- Don't use `StateProvider` — prefer `NotifierProvider` for explicit mutations.
- Don't put UI logic (showing dialogs, navigation) inside providers.
- Don't chain too many `.family` modifiers — if a provider needs 3+ params, create a params class.
