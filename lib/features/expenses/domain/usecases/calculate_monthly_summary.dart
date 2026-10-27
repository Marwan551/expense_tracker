import 'package:expense_tracker/features/expenses/domain/entities/expense.dart';

class MonthlySummary {
  final int totalInPiasters;
  final Map<String, int> categoryTotals;

  const MonthlySummary({
    required this.totalInPiasters,
    required this.categoryTotals,
  });

  Map<String, double> get categoryPercentages {
    if (totalInPiasters == 0) {
      return {};
    }

    final percentages = <String, double>{};

    categoryTotals.forEach((category, total) {
      percentages[category] =
          total * 100.0 / totalInPiasters;
    });

    return percentages;
  }
}

class CalculateMonthlySummary {
  MonthlySummary call({
    required List<Expense> expenses,
    required DateTime month,
  }) {
    final start = DateTime(month.year, month.month, 1);
    final end = DateTime(month.year, month.month + 1, 1);

    final categoryTotals = <String, int>{};
    var total = 0;

    for (final expense in expenses) {
      if (expense.date.isBefore(start) ||
          !expense.date.isBefore(end)) {
        continue;
      }

      total += expense.amount;

      categoryTotals[expense.category] =
          (categoryTotals[expense.category] ?? 0) +
              expense.amount;
    }

    return MonthlySummary(
      totalInPiasters: total,
      categoryTotals: categoryTotals,
    );
  }
}
