import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/expense.dart';
import 'expense_providers.dart';

final expenseNotifierProvider = Provider<ExpenseNotifier>((ref) {
  return ExpenseNotifier(ref);
});

class ExpenseNotifier {
  final Ref ref;

  ExpenseNotifier(this.ref);

  Future<void> saveExpense(Expense expense) async {
    await ref.read(saveExpenseProvider).call(expense);
  }

  Future<void> deleteExpense(int id) async {
    await ref.read(deleteExpenseProvider).call(id);
  }
}
