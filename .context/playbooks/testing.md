# Testing Playbook

## Philosophy: Test-Driven Development

All unit-testable logic MUST follow the Red-Green-Refactor cycle:

1. **Red** — Write a failing test that defines the expected behavior
2. **Green** — Write the minimum code to make the test pass
3. **Refactor** — Clean up while keeping tests green

Never write implementation code without a corresponding failing test first.

## Running Tests

```bash
flutter test                          # all tests
flutter test test/provider_test.dart  # single file
flutter test --name "singleTuneProvider"  # by name
```

## Test Structure

Tests live in `test/` mirroring the lib structure:

- `test/provider_test.dart` — Riverpod provider integration tests
- `test/thesession_tune_source_test.dart` — data parsing unit tests
- `test/database_test.dart` — database operation tests
- `test/drift/` — schema migration verification tests

## Writing Database Tests

Use an in-memory database to avoid filesystem dependencies:

```dart
import 'package:drift/native.dart';
import 'package:drift/drift.dart' as drift;

late AppDatabase db;
late ProviderContainer container;

setUp(() {
  db = AppDatabase(
    drift.DatabaseConnection(
      NativeDatabase.memory(),
      closeStreamsSynchronously: true,
    ),
  );
  container = ProviderContainer(
    overrides: [databaseProvider.overrideWithValue(db)],
  );
});

tearDown(() async {
  await db.close();
  container.dispose();
});
```

## Writing Provider Tests

Use `ProviderContainer` with overrides — never depend on a real database or widget tree for provider logic tests:

```dart
final container = ProviderContainer(
  overrides: [databaseProvider.overrideWithValue(db)],
);

final sub = container.listen<AsyncValue<List<Tune>>>(
  allTunesProvider,
  (previous, next) => emitted.add(next),
  fireImmediately: true,
);
```

## What to Test

- DAOs: insert, update, delete, query operations
- Providers: stream emissions, state transitions, error handling
- Data parsing: external data format conversion (e.g., TheSession JSON)
- Filters/sort logic: pure functions in isolation
- Domain logic: any business rules not tied to UI

## What NOT to Unit Test

- Widget layout (use integration/golden tests for that)
- Generated code (`.g.dart` files)
- Simple pass-through constructors
