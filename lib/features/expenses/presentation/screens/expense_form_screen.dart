import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:expense_tracker/core/utils/app_utils.dart';
import '../../domain/entities/expense.dart';
import '../providers/expense_notifier.dart';
import '../widgets/expense_form_fields.dart';

class ExpenseFormScreen extends ConsumerStatefulWidget {
  final Expense? expense;

  const ExpenseFormScreen({super.key, this.expense});

  @override
  ConsumerState<ExpenseFormScreen> createState() => _ExpenseFormScreenState();
}

class _ExpenseFormScreenState extends ConsumerState<ExpenseFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _amountController;
  late final TextEditingController _noteController;

  String _selectedCategory = AppUtils.categories.first;
  DateTime _selectedDate = DateTime.now();

  final List<String> _categories = List.from(AppUtils.categories);

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController(
      text: widget.expense != null ? widget.expense!.amount.toString() : '',
    );
    _noteController = TextEditingController(
      text: widget.expense?.note ?? '',
    );
    if (widget.expense != null) {
      _selectedCategory = widget.expense!.category;
      _selectedDate = widget.expense!.date;
      if (!_categories.contains(_selectedCategory)) {
        _categories.add(_selectedCategory);
      }
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _saveForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        final amount = int.parse(_amountController.text.trim());
        final expense = Expense(
          id: widget.expense?.id,
          amount: amount,
          category: _selectedCategory,
          date: _selectedDate,
          note: _noteController.text.trim().isEmpty
              ? null
              : _noteController.text.trim(),
        );

        await ref.read(expenseNotifierProvider).saveExpense(expense);

        if (mounted) {
          Navigator.of(context).pop();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${e.toString()}'), backgroundColor: Colors.red),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.expense != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Expense' : 'Add Expense'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              ExpenseFormFields(
                amountController: _amountController,
                noteController: _noteController,
                selectedCategory: _selectedCategory,
                categories: _categories,
                onCategoryChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _selectedCategory = value;
                    });
                  }
                },
                selectedDate: _selectedDate,
                onDateTap: () => _selectDate(context),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _saveForm,
                child: Text(isEditing ? 'Update Expense' : 'Save Expense'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
