import 'package:flutter/material.dart';

class ExpenseFormFields extends StatelessWidget {
  final TextEditingController amountController;
  final TextEditingController noteController;
  final String selectedCategory;
  final List<String> categories;
  final ValueChanged<String?> onCategoryChanged;
  final DateTime selectedDate;
  final VoidCallback onDateTap;

  const ExpenseFormFields({
    super.key,
    required this.amountController,
    required this.noteController,
    required this.selectedCategory,
    required this.categories,
    required this.onCategoryChanged,
    required this.selectedDate,
    required this.onDateTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          controller: amountController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Amount',
            prefixText: '\$ ',
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter an amount';
            }
            final n = int.tryParse(value.trim());
            if (n == null || n <= 0) {
              return 'Please enter a valid positive number';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<String>(
          initialValue: selectedCategory,
          decoration: const InputDecoration(
            labelText: 'Category',
            border: OutlineInputBorder(),
          ),
          items: categories
              .map((cat) => DropdownMenuItem(
                    value: cat,
                    child: Text(cat),
                  ))
              .toList(),
          onChanged: onCategoryChanged,
        ),
        const SizedBox(height: 16),
        InkWell(
          onTap: onDateTap,
          child: InputDecorator(
            decoration: const InputDecoration(
              labelText: 'Date',
              border: OutlineInputBorder(),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}',
                ),
                const Icon(Icons.calendar_today),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: noteController,
          decoration: const InputDecoration(
            labelText: 'Note (Optional)',
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
        ),
      ],
    );
  }
}
