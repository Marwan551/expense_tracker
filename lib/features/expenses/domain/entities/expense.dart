class Expense {

  final int? id;
  final int amount;
  final String category;
  final DateTime date;
  final String? note;

  const Expense({
    this.id,
    required this.amount,
    required this.category,
    required this.date,
    this.note,

  });
}