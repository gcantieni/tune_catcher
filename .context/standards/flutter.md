# Flutter Standards

## Project Principles

- **Test-Driven Development** — Write a failing test before writing implementation code. No exceptions for unit-testable logic.
- **Offline-first** — All data lives locally in SQLite via Drift. Network features are supplementary.
- **Feature isolation** — Each feature module under `lib/feat/` is self-contained. Cross-feature communication happens through providers.
- **Minimal abstraction** — Don't introduce layers or indirection without a concrete need. Three similar lines are better than a premature abstraction.

## Widget Guidelines

- Prefer `StatelessWidget` or `ConsumerWidget`. Use `StatefulWidget` only when managing focus nodes, animation controllers, or text editing controllers.
- Keep `build()` methods short. Extract sub-trees into private methods or separate widgets when a build method exceeds ~50 lines.
- Use `const` constructors wherever possible.
- Never perform side effects in `build()`. Use `ref.listen()` for reacting to state changes.

## State Management (Riverpod)

- All shared state flows through Riverpod providers.
- Use `autoDispose` on providers unless the data must outlive all listeners.
- Prefer `StreamProvider` for reactive database queries.
- Use `Notifier` / `AsyncNotifier` for mutable state with defined mutation methods.
- Override `databaseProvider` in tests — never construct a real database in test code.

## Code Style

- Follow `package:lint/strict.yaml` rules.
- No `print()` calls in production code.
- Use named parameters for constructors with more than two arguments.
- Enum values use `camelCase`.
- File names use `snake_case`.
- One public class per file (private helpers are fine in the same file).

## Error Handling

- Let Drift handle constraint violations — don't duplicate validation in Dart when the DB enforces it.
- Use `AsyncValue.guard()` for provider error propagation.
- Surface errors to the user via SnackBar or inline messages, never silently swallow them.

## Navigation

- All routes are defined in `lib/routing/app_router.dart` using GoRouter.
- Use named routes (`context.goNamed(...)`) rather than path strings.
- Pass IDs as path parameters, not whole objects.
