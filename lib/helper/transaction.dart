enum TransactionType {
  expense,
  income,
}

class Transaction {
  final String title;
  final double amount;
  final String category;
  final TransactionType type;
  final DateTime date;

  const Transaction({
    required this.title,
    required this.amount,
    required this.category,
    required this.type,
    required this.date,
  });
}
