import 'package:flutter/material.dart';
import 'package:expense_tracker/core/utils/app_utils.dart';
import '../../domain/entities/expense.dart';
import 'expense_card.dart';

class DayExpenseGroup extends StatelessWidget {
  final DateTime date;
  final List<Expense> expenses;
  final Function(int) onDelete;
  final Function(Expense) onTab;

  const DayExpenseGroup({
    super.key,
    required this.date,
    required this.expenses,
    required this.onDelete,
    required this.onTab,
  });

  @override
  Widget build(BuildContext context) {
    final total = expenses.fold(0, (sum, expense) => sum + expense.amount);
    final dateStr = AppUtils.formatDate(date);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                dateStr,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                AppUtils.formatCurrency(total),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        ...expenses.map((expense) => Dismissible(
              key: Key(expense.id?.toString() ?? expense.hashCode.toString()),
              direction: DismissDirection.endToStart,
              background: Container(
                color: Colors.red,
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: const Icon(Icons.delete, color: Colors.white),
              ),
              onDismissed: (direction) {
                if (expense.id != null) {
                  onDelete(expense.id!);
                }
              },
              child: ExpenseCard(
                expense: expense,
                onDelete: expense.id != null
                    ? () => onDelete(expense.id!)
                    : null,
                onTap: () => onTab(expense),
              ),
            )),
      ],
    );
  }
}
