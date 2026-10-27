import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:expense_tracker/core/utils/app_utils.dart';
import '../../domain/entities/expense.dart';
import '../../domain/usecases/filter_expenses.dart';
import '../providers/expense_filter_provider.dart';
import '../providers/expense_notifier.dart';
import '../widgets/day_expense_group.dart';
import '../widgets/expense_filter_bar.dart';
import 'expense_form_screen.dart';
import 'monthly_summary_screen.dart';

class ExpenseListScreen extends ConsumerStatefulWidget {
  const ExpenseListScreen({super.key});

  @override
  ConsumerState<ExpenseListScreen> createState() => _ExpenseListScreenState();
}

class _ExpenseListScreenState extends ConsumerState<ExpenseListScreen> {
  final List<String> _categories = AppUtils.categories;

  @override
  Widget build(BuildContext context) {
    final filteredExpensesAsync = ref.watch(filteredExpensesProvider);
    final filterState = ref.watch(expenseFilterProvider);
    final filterNotifier = ref.read(expenseFilterProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense Tracker'),
        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart),
            tooltip: 'Monthly Summary',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const MonthlySummaryScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                DropdownButton<ExpenseDateFilter>(
                  value: filterState.dateFilter,
                  items: const [
                    DropdownMenuItem(
                      value: ExpenseDateFilter.all,
                      child: Text('All Dates'),
                    ),
                    DropdownMenuItem(
                      value: ExpenseDateFilter.thisWeek,
                      child: Text('This Week'),
                    ),
                    DropdownMenuItem(
                      value: ExpenseDateFilter.thisMonth,
                      child: Text('This Month'),
                    ),
                    DropdownMenuItem(
                      value: ExpenseDateFilter.custom,
                      child: Text('Custom Range'),
                    ),
                  ],
                  onChanged: (value) async {
                    if (value == ExpenseDateFilter.custom) {
                      final pickedRange = await showDateRangePicker(
                        context: context,
                        firstDate: DateTime(2000),
                        lastDate: DateTime.now(),
                      );
                      if (pickedRange != null) {
                        filterNotifier.setCustomRange(
                          pickedRange.start,
                          pickedRange.end,
                        );
                      }
                    } else if (value != null) {
                      filterNotifier.setDateFilter(value);
                    }
                  },
                ),
                if (filterState.dateFilter != ExpenseDateFilter.all ||
                    filterState.category != null)
                  TextButton(
                    onPressed: () {
                      filterNotifier.clearFilters();
                    },
                    child: const Text('Clear Filters'),
                  ),
              ],
            ),
          ),

          ExpenseFilterBar(
            selectedCategory: filterState.category,
            categories: _categories,
            onCategorySelected: (category) {
              filterNotifier.setCategory(category);
            },
          ),
          const Divider(),

          Expanded(
            child: filteredExpensesAsync.when(
              data: (expenses) {
                if (expenses.isEmpty) {
                  return const Center(
                    child: Text('No expenses found matching filters.'),
                  );
                }

                final Map<DateTime, List<Expense>> grouped = {};
                for (final expense in expenses) {
                  final dayKey = AppUtils.startOfDay(expense.date);
                  grouped.putIfAbsent(dayKey, () => []).add(expense);
                }

                final sortedDays = grouped.keys.toList()
                  ..sort((a, b) => b.compareTo(a));

                return ListView.builder(
                  itemCount: sortedDays.length,
                  itemBuilder: (context, index) {
                    final day = sortedDays[index];
                    final dayExpenses = grouped[day]!;
                    return DayExpenseGroup(
                      date: day,
                      expenses: dayExpenses,
                      onDelete: (id) async {
                        final target = dayExpenses.firstWhere((e) => e.id == id);
                        await ref.read(expenseNotifierProvider).deleteExpense(id);
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Deleted ${target.category}'),
                              action: SnackBarAction(
                                label: 'Undo',
                                onPressed: () async {
                                  final restored = Expense(
                                    id: null,
                                    amount: target.amount,
                                    category: target.category,
                                    date: target.date,
                                    note: target.note,
                                  );
                                  await ref.read(expenseNotifierProvider).saveExpense(restored);
                                },
                              ),
                            ),
                          );
                        }
                      },
                      onTab: (exp) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ExpenseFormScreen(expense: exp),
                          ),
                        );
                      },
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text('Error: $err')),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const ExpenseFormScreen(),
            ),
          );
        },
        tooltip: 'Add Expense',
        child: const Icon(Icons.add),
      ),
    );
  }
}
