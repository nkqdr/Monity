import 'package:finance_buddy/helper/transaction.dart';

class TransactionsApi {
  static List<Transaction> getTransactions() {
    return transactionList;
  }

  static List<String> getCategories() {
    return categoryList;
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

List<String> categoryList = [
  "Miete",
  "Essen",
  "Freizeit",
];

List<Transaction> transactionList = [
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
  Transaction(
    title: 'Rewe',
    amount: 5.11,
    type: TransactionType.expense,
    category: 'Essen',
    date: DateTime(2021, 9, 21),
  ),
  Transaction(
    title: 'Rewe',
    amount: 5.11,
    type: TransactionType.expense,
    category: 'Essen',
    date: DateTime(2021, 9, 21),
  ),
  Transaction(
    title: "Sela's",
    amount: 5,
    type: TransactionType.expense,
    category: 'Essen',
    date: DateTime(2021, 8, 11),
  ),
  Transaction(
    title: 'Test',
    amount: 51.11,
    type: TransactionType.expense,
    category: 'Essen',
    date: DateTime(2021, 8, 12),
  ),
];
