import 'package:drift/drift.dart';
import 'package:expense_tracker/core/database/app_database.dart' as db;
import 'package:expense_tracker/features/expenses/domain/entities/expense.dart';

class ExpenseModel extends Expense {
  const ExpenseModel({
    super.id,
    required super.amount,
    required super.category,
    required super.date,
    super.note,
  });

  factory ExpenseModel.fromEntity(Expense expense) {
    return ExpenseModel(
      id: expense.id,
      amount: expense.amount,
      category: expense.category,
      date: expense.date,
      note: expense.note,
    );
  }

  factory ExpenseModel.fromDatabase(db.ExpenseEntity entity) {
    return ExpenseModel(
      id: entity.id,
      amount: entity.amount,
      category: entity.category,
      date: entity.date,
      note: entity.note,
    );
  }

  db.ExpensesCompanion toCompanion() {
    return db.ExpensesCompanion(
      id: id != null ? Value(id!) : const Value.absent(),
      amount: Value(amount),
      category: Value(category),
      date: Value(date),
      note: Value(note),
    );
  }

  db.ExpensesCompanion toInsertCompanion() {
    return db.ExpensesCompanion.insert(
      amount: amount,
      category: category,
      date: date,
      note: Value(note),
    );
  }
}
