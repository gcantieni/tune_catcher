# Adding a Feature

## Steps

1. **Define the data model** — If the feature needs new persistent state, add or modify tables in `lib/model/tables/`. Run code generation and handle migrations.

2. **Write failing tests** — Before writing any logic, create tests that specify the expected behavior of DAOs, providers, or domain functions.

3. **Implement the data layer** — Add or extend DAOs in `lib/model/accessors/` and expose via providers in `lib/model/providers/`.

4. **Make tests pass** — Implement the minimum logic to satisfy your tests.

5. **Build the UI** — Create a feature module under `lib/feat/<feature_name>/`. Pages consume providers via `ref.watch()`.

6. **Wire up routing** — Add routes in `lib/routing/app_router.dart` if the feature has its own page.

7. **Verify in-app** — Run the app on a target device and test the golden path plus edge cases.

## Feature Module Convention

Each feature lives in `lib/feat/<name>/` and contains:
- Page widgets (stateless where possible, use `ConsumerWidget` for provider access)
- Feature-specific notifiers or state classes
- No direct database imports — always go through providers

## Adding a New Provider

1. Create the provider in `lib/model/providers/`
2. Depend on `databaseProvider` for DB access
3. Use `StreamProvider.autoDispose` for reactive queries
4. Use `FutureProvider` for one-shot operations
5. Write a test verifying emissions before building UI
