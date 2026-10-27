import 'package:expense_tracker/features/expenses/domain/entities/expense.dart';

enum ExpenseDateFilter {
  all,
  thisWeek,
  thisMonth,
  custom,
}

class FilterExpenses {
  List<Expense> call({
    required List<Expense> expenses,
    ExpenseDateFilter dateFilter = ExpenseDateFilter.all,
    String? category,
    DateTime? customStart,
    DateTime? customEnd,
    DateTime? now,
  }) {
    final currentDate = now ?? DateTime.now();

    final today = DateTime(
      currentDate.year,
      currentDate.month,
      currentDate.day,
    );

    DateTime? start;
    DateTime? endExclusive;

    if (dateFilter == ExpenseDateFilter.thisWeek) {
      start = today.subtract(
        Duration(days: today.weekday - 1),
      );
      endExclusive = start.add(const Duration(days: 7));
    } else if (dateFilter == ExpenseDateFilter.thisMonth) {
      start = DateTime(today.year, today.month, 1);
      endExclusive = DateTime(today.year, today.month + 1, 1);
    } else if (dateFilter == ExpenseDateFilter.custom) {
      if (customStart == null || customEnd == null) {
        throw ArgumentError(
          'Choose both a start date and an end date.',
        );
      }

      start = DateTime(
        customStart.year,
        customStart.month,
        customStart.day,
      );

      endExclusive = DateTime(
        customEnd.year,
        customEnd.month,
        customEnd.day,
      ).add(const Duration(days: 1));

      if (endExclusive.isBefore(start) ||
          endExclusive.isAtSameMomentAs(start)) {
        throw ArgumentError(
          'The end date must not be before the start date.',
        );
      }
    }

    return expenses.where((expense) {
      final matchesCategory =
          category == null ||
              category.isEmpty ||
              expense.category == category;

      final matchesStart =
          start == null || !expense.date.isBefore(start);

      final matchesEnd =
          endExclusive == null ||
              expense.date.isBefore(endExclusive);

      return matchesCategory && matchesStart && matchesEnd;
    }).toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }
}
