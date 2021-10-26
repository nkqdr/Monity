import 'package:finance_buddy/helper/transaction.dart';

class TransactionsApi {
  static List<Transaction> transactionList = [
    Transaction(
      title: 'Watch',
      amount: 699,
      type: TransactionType.expense,
      category: 'Geschenke',
      date: DateTime.now(),
    ),
    Transaction(
      title: 'Tutoring',
      amount: 430.70,
      type: TransactionType.income,
      category: 'Arbeit',
      date: DateTime.now(),
    ),
    Transaction(
      title: 'Rewe',
      amount: 2.31,
      type: TransactionType.expense,
      category: 'Essen',
      date: DateTime.now(),
    ),
    Transaction(
      title: 'Rewe',
      amount: 5.11,
      type: TransactionType.expense,
      category: 'Essen',
      date: DateTime(2021, 9, 21),
    ),
  ];

  static List<Transaction> getTransactions() {
    return transactionList;
  }

  static List<DateTime> getAllMonths() {
    return transactionList
        .map((e) => DateTime(e.date.year, e.date.month))
        .toSet()
        .toList();
  }

  static List<Transaction> getTransactionsFor(DateTime date) {
    return transactionList
        .where((element) =>
            element.date.year == date.year && element.date.month == date.month)
        .toList();
  }
}
