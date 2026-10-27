import 'package:expense_tracker/core/database/app_database.dart';

class ExpenseDatabase {
  final AppDatabase database;

  ExpenseDatabase(this.database);

  Future<List<ExpenseEntity>> getExpenses() async {
    return database.select(database.expenses).get();
  }

  Stream<List<ExpenseEntity>> watchExpenses() {
    return database.select(database.expenses).watch();
  }

  Future<int> insertExpense(ExpensesCompanion expense) {
    return database.into(database.expenses).insert(expense);
  }

  Future<bool> updateExpense(int id, ExpensesCompanion expense) {
    return (database.update(database.expenses)
          ..where((table) => table.id.equals(id)))
        .write(expense)
        .then((rowsUpdated) => rowsUpdated > 0);
  }

  Future<int> deleteExpense(int id) {
    return (database.delete(database.expenses)
          ..where((table) => table.id.equals(id)))
        .go();
  }
}
