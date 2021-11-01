import 'package:finance_buddy/backend/finances_database.dart';
import 'package:finance_buddy/backend/models/transaction_model.dart';

class TransactionsApi {
  static Future<List<Transaction>> getTransactions() async {
    return FinancesDatabase.instance.readAllTransactions();
  }
}
