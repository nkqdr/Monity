import 'package:finance_buddy/helper/transaction.dart';

const String tableTransaction = "transaction";
const String tableTransactionCategory = "transaction_category";

class TransactionFields {
  static const List<String> values = [
    id,
    description,
    category,
    amount,
    date,
    type
  ];
  static const String id = "_id";
  static const String description = "description";
  static const String category = "category_id";
  static const String amount = "amount";
  static const String date = "date";
  static const String type = "type";
}

class TransactionCategoryFields {
  static const List<String> values = [id, name];
  static const String id = "_id";
  static const String name = "name";
}

class Transaction {
  final int? id;
  final String? description;
  final int category;
  final double amount;
  final DateTime date;
  final TransactionType type;

  const Transaction({
    this.id,
    this.description,
    required this.category,
    required this.amount,
    required this.date,
    required this.type,
  });

  Map<String, Object?> toJson() {
    return {
      TransactionFields.id: id,
      TransactionFields.description: description,
      TransactionFields.category: category,
      TransactionFields.amount: amount,
      TransactionFields.date: date.toIso8601String(),
      TransactionFields.type: type.index,
    };
  }

  static Transaction fromJson(Map<String, Object?> json) {
    return Transaction(
      id: json[TransactionFields.id] as int?,
      description: json[TransactionFields.description] as String,
      category: json[TransactionFields.category] as int,
      amount: json[TransactionFields.amount] as double,
      date: DateTime.parse(json[TransactionFields.date] as String),
      type: TransactionType.values[json[TransactionFields.type] as int],
    );
  }

  Transaction copy({
    int? id,
    String? description,
    int? category,
    double? amount,
    DateTime? date,
    TransactionType? type,
  }) {
    return Transaction(
      id: id ?? this.id,
      description: description ?? this.description,
      category: category ?? this.category,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      type: type ?? this.type,
    );
  }
}

class TransactionCategory {
  final int? id;
  final String name;

  const TransactionCategory({
    this.id,
    required this.name,
  });
}
