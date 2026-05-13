# Tune Trove

A Flutter app for recording, learning, and mastering traditional folk tunes. Built for musicians who want to catalog tunes they encounter at sessions, link them to recordings, and track their learning progress.

## Architecture

The app follows a layered architecture with clear separation of concerns:

```
lib/
├── main.dart                  # App entry, ProviderScope + MaterialApp.router
├── domain/                    # Domain types and error definitions
├── model/                     # Data layer (Drift database + Riverpod providers)
│   ├── tables/                # Drift table definitions (Tunes, Recordings, TuneRecording)
│   ├── accessors/             # DAOs (TuneDao, RecordingDao, TuneRecordingDao)
│   ├── providers/             # Riverpod providers exposing streams/futures from DAOs
│   ├── database.dart          # @DriftDatabase definition + migrations
│   └── database_provider.dart # Top-level Riverpod Provider<AppDatabase>
├── feat/                      # Feature modules (UI + feature-specific logic)
│   ├── abc_render/            # ABC notation → sheet music rendering via WebView
│   ├── recorder/              # Audio recording capture
│   ├── recording_list/        # Recording CRUD + detail views
│   ├── set_list/              # Set list management
│   └── tune_list/             # Tune browsing with filter/sort/search
├── remote_tune_sources/       # External data (TheSession.org tune import)
├── routing/                   # GoRouter config + NavScaffold shell
└── shared_widgets/            # Reusable dialogs and pickers
```

## Key Dependencies

| Package                   | Purpose                                         |
| ------------------------- | ----------------------------------------------- |
| `flutter_riverpod`        | State management and dependency injection       |
| `drift` + `drift_flutter` | Type-safe SQLite database with reactive streams |
| `go_router`               | Declarative routing with shell-based navigation |
| `flutter_inappwebview`    | WebView for ABC notation rendering (abcjs)      |
| `http` + `html`           | HTTP fetching and HTML parsing for tune sources |
| `flutter_svg`             | SVG rendering                                   |
| `url_launcher`            | Opening external URLs                           |

## Data Model

- **Tunes** — a tune definition (name, ABC notation, key, type, genre, status, etc.)
- **Recordings** — a named recording reference (URL-based, no local file storage)
- **TuneRecording** — many-to-many link between tunes and recordings (with optional timestamp markers and performer info)

## Navigation

Four primary routes via bottom nav: Set List → Tune List → Recording List → Recorder (initial location). Directional slide transitions based on nav position.

## Development Standards

Follow TDD for all code changes:

1. **Red** — write a failing unit test that captures the desired behavior (`make test`)
2. **Green** — write the minimal code to make it pass (`make test`)

After completing any code changes, always run:

```
make format
make analyze
make test
```

When adding or changing packages in `pubspec.yaml`, run:

```
make deps
```

## Context Files

- [.context/playbooks/](/.context/playbooks/) — Step-by-step guides for common development actions
- [.context/standards/](/.context/standards/) — Best practices and coding standards
