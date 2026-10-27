
import '../entities/expense.dart';
import '../repositories/expense_repository.dart';

class WatchExpenses {
  final ExpenseRepository repository;

  WatchExpenses(this.repository);

  Stream<List<Expense>> call() {
    return repository.watchExpenses();
  }
}
