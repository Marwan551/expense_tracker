import 'package:flutter_test/flutter_test.dart';
import 'package:expense_tracker/features/expenses/domain/entities/expense.dart';
import 'package:expense_tracker/features/expenses/domain/usecases/filter_expenses.dart';
import 'package:expense_tracker/features/expenses/domain/usecases/calculate_monthly_summary.dart';

Expense expense(int id, int amount, String category, DateTime date) =>
    Expense(id: id, amount: amount, category: category, date: date);

void main() {
  final now = DateTime(2026, 11, 24, 12);
  group('Expense filtering', () {
    test('all returns newest first without changing the input order', () {
      final input = [
        expense(1, 10, 'Food', DateTime(2026, 11, 1)),
        expense(2, 20, 'Bills', DateTime(2026, 11, 3)),
      ];
      expect(FilterExpenses()(expenses: input).map((x) => x.id), [2, 1]);
      expect(input.map((x) => x.id), [1, 2]);
    });
    test('combines month boundaries and category', () {
      final input = [
        expense(1, 1, 'Food', DateTime(2026, 10, 31, 23, 59)),
        expense(2, 1, 'Food', DateTime(2026, 11, 1)),
        expense(3, 1, 'Food', DateTime(2026, 11, 30, 23, 59)),
        expense(4, 1, 'Food', DateTime(2026, 12, 1)),
        expense(5, 1, 'Bills', DateTime(2026, 11, 15)),
      ];
      final result = FilterExpenses()(
        expenses: input,
        dateFilter: ExpenseDateFilter.thisMonth,
        category: 'Food',
        now: now,
      );
      expect(result.map((x) => x.id), [3, 2]);
    });
    test('week starts Monday and excludes the following Monday', () {
      final input = [
        expense(1, 1, 'Food', DateTime(2026, 11, 22)),
        expense(2, 1, 'Food', DateTime(2026, 11, 23)),
        expense(3, 1, 'Food', DateTime(2026, 11, 29, 23, 59)),
        expense(4, 1, 'Food', DateTime(2026, 11, 30)),
      ];
      expect(
        FilterExpenses()(
          expenses: input,
          dateFilter: ExpenseDateFilter.thisWeek,
          now: now,
        ).map((x) => x.id),
        [3, 2],
      );
    });
    test('custom date includes the complete end day', () {
      final input = [
        expense(1, 1, 'Food', DateTime(2026, 11, 24, 23, 59)),
        expense(2, 1, 'Food', DateTime(2026, 11, 25)),
      ];
      expect(
        FilterExpenses()(
          expenses: input,
          dateFilter: ExpenseDateFilter.custom,
          customStart: now,
          customEnd: now,
        ).map((x) => x.id),
        [1],
      );
    });
    test('rejects missing and reversed custom bounds', () {
      expect(
        () => FilterExpenses()(
          expenses: [],
          dateFilter: ExpenseDateFilter.custom,
        ),
        throwsArgumentError,
      );
      expect(
        () => FilterExpenses()(
          expenses: [],
          dateFilter: ExpenseDateFilter.custom,
          customStart: DateTime(2026, 11, 25),
          customEnd: now,
        ),
        throwsArgumentError,
      );
    });
    test('empty input returns an empty result', () {
      expect(FilterExpenses()(expenses: []), isEmpty);
    });
  });
  group('Monthly summary', () {
    test('totals only the selected month and groups categories', () {
      final result = CalculateMonthlySummary()(
        month: now,
        expenses: [
          expense(1, 10, 'Food', DateTime(2026, 11, 1)),
          expense(2, 20, 'Food', DateTime(2026, 11, 2)),
          expense(3, 70, 'Bills', DateTime(2026, 11, 30, 23, 59)),
          expense(4, 999, 'Food', DateTime(2026, 12, 1)),
        ],
      );
      expect(result.totalInPiasters, 100);
      expect(result.categoryTotals, {'Food': 30, 'Bills': 70});
      expect(result.categoryPercentages['Food'], closeTo(30, 0.001));
      expect(result.categoryPercentages['Bills'], closeTo(70, 0.001));
    });
    test('empty month has no percentages and no division by zero', () {
      final result = CalculateMonthlySummary()(month: now, expenses: []);
      expect(result.totalInPiasters, 0);
      expect(result.categoryTotals, isEmpty);
      expect(result.categoryPercentages, isEmpty);
    });
    test('December boundaries roll into the next year', () {
      final result = CalculateMonthlySummary()(
        month: DateTime(2026, 12),
        expenses: [
          expense(1, 5, 'Food', DateTime(2026, 12, 31, 23, 59)),
          expense(2, 9, 'Food', DateTime(2027, 1, 1)),
        ],
      );
      expect(result.totalInPiasters, 5);
    });
  });
}
