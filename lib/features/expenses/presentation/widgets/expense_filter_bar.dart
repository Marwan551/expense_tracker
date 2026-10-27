import 'package:flutter/material.dart';

class ExpenseFilterBar extends StatelessWidget {
  final String? selectedCategory;
  final List<String> categories;
  final ValueChanged<String?> onCategorySelected;

  const ExpenseFilterBar({
    super.key,
    required this.selectedCategory,
    required this.categories,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          ChoiceChip(
            label: const Text('All'),
            selected: selectedCategory == null,
            onSelected: (selected) {
              if (selected) onCategorySelected(null);
            },
          ),
          const SizedBox(width: 8),
          ...categories.map((category) {
            return Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: ChoiceChip(
                label: Text(category),
                selected: selectedCategory == category,
                onSelected: (selected) {
                  onCategorySelected(selected ? category : null);
                },
              ),
            );
          }),
        ],
      ),
    );
  }
}
