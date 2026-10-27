import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/expense.dart';
import '../../domain/usecases/filter_expenses.dart';
import 'expense_providers.dart';

class ExpenseFilterState {
  final ExpenseDateFilter dateFilter;
  final String? category;
  final DateTime? customStart;
  final DateTime? customEnd;

  const ExpenseFilterState({
    this.dateFilter = ExpenseDateFilter.all,
    this.category,
    this.customStart,
    this.customEnd,
  });

  ExpenseFilterState copyWith({
    ExpenseDateFilter? dateFilter,
    String? category,
    DateTime? customStart,
    DateTime? customEnd,
    bool clearCategory = false,
    bool clearCustomRange = false,
  }) {
    return ExpenseFilterState(
      dateFilter: dateFilter ?? this.dateFilter,
      category: clearCategory ? null : category ?? this.category,
      customStart:
      clearCustomRange ? null : customStart ?? this.customStart,
      customEnd: clearCustomRange ? null : customEnd ?? this.customEnd,
    );
  }
}

class ExpenseFilterNotifier extends Notifier<ExpenseFilterState> {
  @override
  ExpenseFilterState build() {
    return const ExpenseFilterState();
  }

  void setCategory(String? category) {
    state = state.copyWith(
      category: category,
      clearCategory: category == null,
    );
  }

  void setDateFilter(ExpenseDateFilter filter) {
    state = state.copyWith(
      dateFilter: filter,
      clearCustomRange: filter != ExpenseDateFilter.custom,
    );
  }

  void setCustomRange(DateTime start, DateTime end) {
    state = state.copyWith(
      dateFilter: ExpenseDateFilter.custom,
      customStart: start,
      customEnd: end,
    );
  }

  void clearFilters() {
    state = const ExpenseFilterState();
  }
}

final expenseFilterProvider =
NotifierProvider<ExpenseFilterNotifier, ExpenseFilterState>(
  ExpenseFilterNotifier.new,
);

final filteredExpensesProvider =
Provider<AsyncValue<List<Expense>>>((ref) {
  final expenses = ref.watch(expensesProvider);
  final filters = ref.watch(expenseFilterProvider);
  final filterExpenses = ref.watch(filterExpensesProvider);

  return expenses.whenData((items) {
    return filterExpenses(
      expenses: items,
      dateFilter: filters.dateFilter,
      category: filters.category,
      customStart: filters.customStart,
      customEnd: filters.customEnd,
    );
  });
});
