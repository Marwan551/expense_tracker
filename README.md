# Expense Tracker

A modern, offline-first Flutter application built with Clean Architecture, Riverpod state management, and Drift reactive SQLite database.

---

## Features

- **Expense Management**: Add, edit, and delete expenses with amount validation, category selection, date pickers, and optional notes.
- **Swipe-to-Dismiss with Undo**: Easily delete expenses with a left-swipe gesture, featuring an immediate Undo action in a SnackBar.
- **Advanced Filtering**: Filter expenses by date (`All`, `This Week`, `This Month`, `Custom Date Range`) and category.
- **Monthly Summary & Analytics**: View total monthly spending along with categorical breakdowns, percentage shares, and progress indicators.
- **Reactive Stream Storage**: Real-time UI updates backed by Drift SQLite database streams.

---

## Architecture Rationale

This project follows **Clean Architecture** principles to separate concerns, enforce maintainability, and ensure testability:

1. **Domain Layer (`domain/`)**: 
   - Contains pure business logic, entities ([Expense](file:///F:/expense_tracker/lib/features/expenses/domain/entities/expense.dart)), repository interfaces ([ExpenseRepository](file:///F:/expense_tracker/lib/features/expenses/domain/repositories/expense_repository.dart)), and **Use Cases** (`SaveExpense`, `DeleteExpense`, `WatchExpenses`, `FilterExpenses`, `CalculateMonthlySummary`).
   - Independent of any external frameworks or UI.

2. **Data Layer (`data/`)**: 
   - Implements local data sources using Drift ([ExpenseDatabase](file:///F:/expense_tracker/lib/features/expenses/data/datasources/expense_local_data_source.dart)), repository implementations ([ExpenseRepositoryImpl](file:///F:/expense_tracker/lib/features/expenses/data/repositories/expense_repository_impl.dart)), and data models ([ExpenseModel](file:///F:/expense_tracker/lib/features/expenses/data/models/expense_model.dart)).

3. **Presentation Layer (`presentation/`)**: 
   - Handles UI screens ([ExpenseListScreen](file:///F:/expense_tracker/lib/features/expenses/presentation/screens/expense_list_screen.dart), [ExpenseFormScreen](file:///F:/expense_tracker/lib/features/expenses/presentation/screens/expense_form_screen.dart), [MonthlySummaryScreen](file:///F:/expense_tracker/lib/features/expenses/presentation/screens/monthly_summary_screen.dart)), reusable widgets, state notifiers ([ExpenseNotifier](file:///F:/expense_tracker/lib/features/expenses/presentation/providers/expense_notifier.dart)), and Riverpod providers.

---

## Packages Chosen & Why

* **`flutter_riverpod`**: Chosen for compile-time safe, testable, and reactive state management and dependency injection without needing BuildContext.
* **`drift` & `sqlite3_flutter_libs`**: Chosen for type-safe, performant, and reactive local SQLite database storage with automatic stream generation.
* **`flutter_test`**: Used for unit and widget testing infrastructure.

---

## Setup & Getting Started

### Prerequisites
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (^3.x.x)
- Dart SDK

### Steps to Run
1. Clone the repository:
   ```bash
   git clone <repository-url>
   cd expense_tracker
   ```
2. Install dependencies:
   ```bash
   flutter pub get
   ```
3. Run code generation (for Drift database tables):
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```
4. Run the application:
   ```bash
   flutter run
   ```

---

## Known Limitations & Future Improvements

- **Local Storage Only**: Currently, data is stored exclusively on-device in a local SQLite database (Drift). Cloud synchronization / authentication could be added in future versions.
- **Currency Support**: Currently operates in a single currency model (stored in piasters/cents). Multi-currency conversion could be added.
- **Export/Import**: CSV/PDF export of expense reports is planned for a future release.
