# Expense Tracker

An offline-first Flutter portfolio app for recording expenses, filtering them by date and category, and viewing monthly totals. It uses Riverpod for state/dependency wiring and Drift with SQLite for local storage.

## Implemented in the source

- Add, edit and delete expenses with a positive-integer amount, category, date and optional note.
- Date filters for all entries, the current week, current month or an inclusive custom date range.
- Category filtering and newest-first results.
- Monthly totals, category totals and percentage breakdowns.
- Local database streams, grouped expense lists and a delete/undo interaction.

## Architecture

- [Domain](lib/features/expenses/domain/): expense entity, repository contract and use cases.
- [Data](lib/features/expenses/data/): Drift data source, models and repository implementation.
- [Presentation](lib/features/expenses/presentation/): screens, widgets and Riverpod providers.
- [Database](lib/core/database/app_database.dart): table definition and database connection.

## Local setup

Use a Flutter SDK with Dart 3.13.5 or later within Dart 3.x, as declared by `pubspec.yaml`. The tests below were checked with Flutter 3.50.1 / Dart 3.14.0 on Linux.

```sh
git clone https://github.com/Marwan551/expense_tracker.git
cd expense_tracker
flutter pub get
flutter analyze
flutter test
```

The generated Drift file is tracked. Regenerate it when the schema or generated models change:

```sh
dart run build_runner build --delete-conflicting-outputs
```

To launch on a configured device or emulator, run `flutter doctor`, then `flutter run`. Local unit tests do not establish that every target platform has been launched successfully.

## Tests

```sh
flutter test test/expense_domain_test.dart
```

Nine domain tests cover category/date filtering, newest-first ordering, unchanged input ordering, complete end-day inclusion, Monday-to-Sunday week boundaries, invalid custom ranges, monthly/category totals, empty data and December-to-January boundaries. The unrelated generated counter test has been removed.

These tests do not cover database persistence, widget interactions or end-to-end device behavior. Static analysis currently reports existing informational deprecation diagnostics, so it is not warning-free.

## Amounts and current limitations

The current form accepts positive whole integers and displays them directly with a `$` prefix. It does not convert minor units to major units. Some internal summary names still say `Piasters`; those names do not match the display semantics and should not be treated as multi-currency support.

- On-device storage only; no cloud sync or user authentication.
- No decimal-amount or currency-selection workflow.
- CSV/PDF export is not implemented.
- Screenshots, a recorded walkthrough and device-level verification remain to be added.
