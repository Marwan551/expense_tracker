import 'package:expense_tracker/features/expenses/domain/repositories/expense_repository.dart';
import 'package:expense_tracker/features/expenses/domain/entities/expense.dart';
import 'package:expense_tracker/features/expenses/data/datasources/expense_local_data_source.dart';
import 'package:expense_tracker/features/expenses/data/models/expense_model.dart';

class ExpenseRepositoryImpl implements ExpenseRepository {
  final ExpenseDatabase expenseDatabase;

  ExpenseRepositoryImpl(this.expenseDatabase);

  @override
  Future<void> addExpense(Expense expense) async {
    final model = ExpenseModel.fromEntity(expense);
    await expenseDatabase.insertExpense(model.toInsertCompanion());
  }

  @override
  Future<void> updateExpense(Expense expense) async {
    if (expense.id == null) return;
    final model = ExpenseModel.fromEntity(expense);
    await expenseDatabase.updateExpense(expense.id!, model.toCompanion());
  }

  @override
  Future<void> deleteExpense(int id) async {
    await expenseDatabase.deleteExpense(id);
  }

  @override
  Stream<List<Expense>> watchExpenses() {
    return expenseDatabase.watchExpenses().map(
          (entities) => entities
              .map<Expense>((entity) => ExpenseModel.fromDatabase(entity))
              .toList(),
        );
  }
}
