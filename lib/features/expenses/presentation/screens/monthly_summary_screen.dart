import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/expense_providers.dart';

class MonthlySummaryScreen extends ConsumerWidget {
  const MonthlySummaryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expensesAsync = ref.watch(expensesProvider);
    final calculateSummary = ref.watch(calculateMonthlySummaryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Monthly Summary'),
      ),
      body: expensesAsync.when(
        data: (expenses) {
          final now = DateTime.now();
          final summary = calculateSummary(expenses: expenses, month: now);
          final totalAmount = summary.totalInPiasters;
          final categoryTotals = summary.categoryTotals;
          final percentages = summary.categoryPercentages;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Total Spent This Month',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '\$$totalAmount',
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Breakdown by Category',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: categoryTotals.isEmpty
                      ? const Center(
                          child: Text('No expenses recorded for this month.'),
                        )
                      : ListView(
                          children: categoryTotals.entries.map((entry) {
                            final pct = percentages[entry.key] ?? 0.0;
                            return ListTile(
                              title: Text(entry.key),
                              subtitle: Padding(
                                padding: const EdgeInsets.only(top: 4.0),
                                child: LinearProgressIndicator(
                                  value: totalAmount > 0
                                      ? entry.value / totalAmount
                                      : 0.0,
                                ),
                              ),
                              trailing: Text(
                                '\$${entry.value} (${pct.toStringAsFixed(1)}%)',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }
}
