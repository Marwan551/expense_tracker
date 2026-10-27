import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/database/app_database.dart';
import '../../data/datasources/expense_local_data_source.dart';
import '../../data/repositories/expense_repository_impl.dart';
import '../../domain/entities/expense.dart';
import '../../domain/repositories/expense_repository.dart';
import '../../domain/usecases/save_expense.dart';
import '../../domain/usecases/delete_expense.dart';
import '../../domain/usecases/watch_expenses.dart';
import '../../domain/usecases/filter_expenses.dart';
import '../../domain/usecases/calculate_monthly_summary.dart';

final databaseProvider = Provider<AppDatabase>((ref) {
  final database = AppDatabase();

  ref.onDispose(() {
    database.close();
  });

  return database;
});


final expenseLocalDataSourceProvider =
Provider<ExpenseDatabase>((ref) {
  final database = ref.watch(databaseProvider);

  return ExpenseDatabase(database);
});


final expenseRepositoryProvider = Provider<ExpenseRepository>((ref) {
  final dataSource = ref.watch(expenseLocalDataSourceProvider);

  return ExpenseRepositoryImpl(dataSource);
});


final saveExpenseProvider = Provider<SaveExpense>((ref) {
  return SaveExpense(ref.watch(expenseRepositoryProvider));
});

final deleteExpenseProvider = Provider<DeleteExpense>((ref) {
  return DeleteExpense(ref.watch(expenseRepositoryProvider));
});

final watchExpensesProvider = Provider<WatchExpenses>((ref) {
  return WatchExpenses(ref.watch(expenseRepositoryProvider));
});

final filterExpensesProvider = Provider<FilterExpenses>((ref) {
  return FilterExpenses();
});

final calculateMonthlySummaryProvider =
Provider<CalculateMonthlySummary>((ref) {
  return CalculateMonthlySummary();
});


final expensesProvider = StreamProvider<List<Expense>>((ref) {
  return ref.watch(watchExpensesProvider).call();
});
