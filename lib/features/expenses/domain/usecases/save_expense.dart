import 'package:expense_tracker/features/expenses/domain/repositories/expense_repository.dart';
import 'package:expense_tracker/features/expenses/domain/entities/expense.dart';

class SaveExpense {
  final ExpenseRepository repository;

  SaveExpense(this.repository);

  Future<void> call(Expense expense) async {
    if (expense.amount <= 0) {
      throw ArgumentError('Amount must be greater than zero.');
    }

    if (expense.category.trim().isEmpty) {
      throw ArgumentError('Please select a category.');
    }

    final today = DateTime.now();
    final selectedDate = expense.date;

    final expenseDay = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
    );

    final todayDate = DateTime(
      today.year,
      today.month,
      today.day,
    );

    if (expenseDay.isAfter(todayDate)) {
      throw ArgumentError('Date cannot be in the future.');
    }

    if (expense.id == null) {
      await repository.addExpense(expense);
    } else {
      await repository.updateExpense(expense);
    }
  }
}
