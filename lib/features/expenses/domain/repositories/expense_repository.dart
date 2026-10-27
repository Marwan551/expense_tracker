import 'package:expense_tracker/features/expenses/domain/entities/expense.dart';

abstract class ExpenseRepository {
  Stream<List<Expense>> watchExpenses();

  Future<void> addExpense(Expense expense);

  Future<void> updateExpense(Expense expense);

  Future<void> deleteExpense(int id);
}
